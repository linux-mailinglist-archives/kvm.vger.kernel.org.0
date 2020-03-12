Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC2DE182C41
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 10:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgCLJUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 05:20:07 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53564 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726385AbgCLJUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 05:20:07 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EDEF9ED6D8587C08CEB4;
        Thu, 12 Mar 2020 17:20:04 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Mar 2020
 17:19:54 +0800
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To:     Marc Zyngier <maz@kernel.org>, Auger Eric <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <drjones@redhat.com>,
        <andre.przywara@arm.com>, <peter.maydell@linaro.org>,
        <alexandru.elisei@arm.com>, <thuth@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
 <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
Date:   Thu, 12 Mar 2020 17:19:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/11 22:00, Marc Zyngier wrote:
> That is still a problem with the ITS. There is no architectural way
> to report an error, even if the error numbers are architected...
> 
> One thing we could do though is to implement the stall model (as described
> in 5.3.2). It still doesn't give us the error, but at least the command
> queue would stop on detecting an error.

It would be interesting to see the buggy guest's behavior under the
stall mode. I've used the following diff (absolutely *not* a formal
patch, don't handle CREADR.Stalled and CWRITER.Retry at all) to have
a try, and caught another command error in the 'its-trigger' test.

logs/its-trigger.log:
" INT dev_id=2 event_id=20
lib/arm64/gic-v3-its-cmd.c:194: assert failed: false: INT timeout! "

dmesg:
[13297.711958] ------------[ cut here ]------------
[13297.711964] ITS command error encoding 0x10307

It's the last INT test in test_its_trigger() who has triggered this
error, Eric?


Thanks.

---8<---
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9d53f545a3d5..5717f5da0f22 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -179,6 +179,7 @@ struct vgic_its {
  	u64			cbaser;
  	u32			creadr;
  	u32			cwriter;
+	bool			stalled;

  	/* migration ABI revision in use */
  	u32			abi_rev;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d53d34a33e35..72422b75e627 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1519,6 +1519,9 @@ static void vgic_its_process_commands(struct kvm 
*kvm, struct vgic_its *its)
  	if (!its->enabled)
  		return;

+	if (unlikely(its->stalled))
+		return;
+
  	cbaser = GITS_CBASER_ADDRESS(its->cbaser);

  	while (its->cwriter != its->creadr) {
@@ -1531,9 +1534,34 @@ static void vgic_its_process_commands(struct kvm 
*kvm, struct vgic_its *its)
  		 * According to section 6.3.2 in the GICv3 spec we can just
  		 * ignore that command then.
  		 */
-		if (!ret)
-			vgic_its_handle_command(kvm, its, cmd_buf);
+		if (ret)
+			goto done;
+
+		ret = vgic_its_handle_command(kvm, its, cmd_buf);
+
+		/*
+		 * Choose the stall mode on detection of command errors.
+		 * Guest still can't get the architected error numbers though...
+		 */
+		if (ret) {
+			/* GITS_CREADR.Stalled is set to 1. */
+			its->stalled = true;
+
+			/*
+			 * GITS_TYPER.SEIS is 0 atm, no System error will be
+			 * generated.  Instead report error encodings at ITS
+			 * level.
+			 */
+			WARN_RATELIMIT(ret, "ITS command error encoding 0x%x", ret);
+
+			/*
+			 * GITS_CREADR is not incremented and continues to
+			 * point to the entry that triggered the error.
+			 */
+			break;
+		}

+done:
  		its->creadr += ITS_CMD_SIZE;
  		if (its->creadr == ITS_CMD_BUFFER_SIZE(its->cbaser))
  			its->creadr = 0;

