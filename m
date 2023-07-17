Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2759C7559AA
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 04:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjGQCgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 22:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjGQCgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 22:36:05 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2010.outbound.protection.outlook.com [40.92.20.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB3DE78;
        Sun, 16 Jul 2023 19:35:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fe3ohdjH+s7nKvejRYyZXbkqr8WY5lIgYh2HAkGtHjlh8Q/8ddIfZtsYEzVOnMEbqB0HAIYDv8g/s0DoGA1in2dg8ZLFSN9k2cFIJ190aSOf6LIXpWwveCm34jZFR5yNVhIfJm7L2TFNVhKVygBa8Uoi1Lr9E/keDcDOocMkCbNhSrJjYyI10EOCh5sxbiunv3RpKjR8JTCZMV+QYVex71MBhEmdqMP696HluBWQNG0gIghYz5pHCre9iDLrVBx/JQBFIGjJA9DwPRfOddB68uVPicoBiICVBK3XDzX+vEJ3T0oKn14X9vToi8B6BlvcY1sxu6FqQufggbBYxzl3YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUjp8oFN6uhJgLi+/6eHU6v9QdieUoPl1Gvg2EydAiM=;
 b=m207MlSQ8d/V6wsgc+X28WEV1nxgzlAh0ALiIJ9XZT+XuiJnyDzxBogRmA9zsu4W2eV8Ri2Z++ALUnYVLVeVzK7lZZXEUjAaHCUaAE3prXGHT08BkMccdm4Kt8yxFVLQlXAAjubzq/bxVbNfEos/a8PCJASS0/gszIHsoY0wk/lOJPSelFHUBCsIEIqjAzhB2YlGmPzSUkc/ayn8gOhsRP30e1PBMvs/nd2tJBJldFaxqQcZDpZkV6rXkEUGkW2qldxVl7GMxuQIBjE+GkrX/g+e1TzsASSt+LDPnVkODXncsXxkOnNk8riyRETf/RbzlAl5mbSSYBZ/YXFUUaRVQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUjp8oFN6uhJgLi+/6eHU6v9QdieUoPl1Gvg2EydAiM=;
 b=Xjc4+uQsulKiBDVqbrQ/+87YwoAs83q6yFHYWkCvZ1Sedh2PrBM4qT9bxiEKXX49AhYSMN7dUx6gIZHY7/8MhUfHZLpJ524lyMYTx+Sy+Q8/9ktuoCQLmwTvWzvAFy8hSA+ZEi1IXlm9NbaBYxAThTEvzQarHQ7QpuiYhf94KTygOq1j59j0othWjc4WsysEyZcBcLNpMB5vEfQrKc1UMlz81aHpX6aIP8Ts9B0yd4apgG30jTwpLdnmXSmrkk2dpmsn6H044zXGymThgPRuYnPGjcCG2AeALinQUApR8c5ujI09FT9OQQTFuDoMf6Ft1VsTOoXQjly8npjQEDHpMw==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by PH0PR03MB6512.namprd03.prod.outlook.com (2603:10b6:510:be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 02:35:55 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 02:35:55 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, zhi.wang.linux@gmail.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC V3 4/6] KVM: x86: do lazy_tscdeadline init and exit
Date:   Mon, 17 Jul 2023 10:35:21 +0800
Message-ID: <BYAPR03MB4133B88E126CB79F0D70C4F7CD3BA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
References: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [qzCBZ9kJ9a8KWxxR7PUY2qvA2SultIkHRU3kdhd7a/8=]
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1689561323-3695-5-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|PH0PR03MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 73de9c30-0fa5-42c1-15cd-08db866e8b6d
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnqpUrHVo6HYXI9uowj33ZBSyQRMRbgv8vJo/V8webtE0xdXHaPyGqjYp9xojOehd8kow0JCW4YoM7BFJH4fW0wHcTA2HUPQQO8pljE3WaQgafboh8nRyYpYltq4XsRfkTI7N5yBKfHYBVpSTdsCzjXnMQaNZOEKAgjmpt1Yxk+rG9Fn1riTJh8K1TA+b8XZXwlO4v643yCoV/xrliezQPBi+M2Z01yRNI+JWbfmUF22GtszpUFiFZL3pmG3a47XjQWJwH2SKrf2LW8gmLjPoFysUW+0Z7cZ3WzSOtSGZ3VG5gx9S6uYHiKm/2bDgx5vChfNgVWZPm7Rk5n+Q9Qog0QHW48WIKhMA2w6d8QwI/SOewVLn8Pun3SdSWKa66nV2DBR28w0sGAjTLmDx9M0+dVhWzBzcUPr93xUwkzdhUog5rjMrfBEzY3BvxOEtx7SG9AU8bQrvpk9ybBhVltaonEm8lxQdXq1jaFW7oM/RCVA2hmptChwk2DuQ+MYpP0AT8AmfYec5iUQqyDYPlPHbMBJALnZBvR/AUtmRGdKMiRIT5TfqgU3HMz7etTUeA7qKxKapXnYFdmhHVBHCFOQlP/2KU67+PIWlGPjSAOQGRNPJbljghurP5X/qNJcU9tDYKT7VnMLPZOh2vL5CtfawOcjyas4IVbhzlm2Da0x5lobWwWB2u5rq1R99/lBVAKXfpgMkEU9dpNuSHZKCVprwvE1/tA+iEYdJQKBB/kjFvAwjvGFIqZfT6vhZj5edBZ6vII=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5U70jnIVuxHLsqeMsIXlIDiMi6d22EStODYE63O99ZmQrFY/gWZDRSv1YmJimJcIhIWZOo7zM1/ql0o2NBZYVwvIqLT5WbvjawvgnNmg7vmFkQ2KBFSZRQICbo2dITgdDJV3MYOrLzrj+6JGt6S+Eu6fht0ICoEwH2ei2X6TjlCGGmn8iKmq499dJu3V4BUkKdprsQ9qp7yHxxe9BOkC1LctY1bxzkkmiA/s1ATxezjyGp7Wv6iZZz1j12V2oqkBHHMWHnPMOtA7GsAIQo4cRyyHy8H3VWUwV7232M/jcqdUaCw6Qt5e5yU90HTM9DmMTHXSTYy1EeuQuVxlHbE8qi4TtPlA+O1ko8FL1wbTRYe7jjW2iXLn3c0Y0EoT30sj/ReVjA7ngPFuwHjaOUZGrueR2faFyvPg3rtNjhTaSpZkAw9WpMdnDd419zhV5M6vo3SvJH8NlP1Sw12kHTDaUAUr446ZcoDyQgDGxO7XIXej0r5EDCDpc4s1DPQ3/Bozo/8927t5ulUXZvZ7szq+YGmBlZvAa0C7ntOUSm49gAYJdZRBl4ViFnmn4b+DHyYO
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y89mWbSs67GRTuGHHqLnNssgaGBB0nFzzHclmsEBrQ3qr4HQGxHUX2PC5szA?=
 =?us-ascii?Q?rEIR0qXzCsmEqEanUeb6qz4/oymkfejMjmHynbboIvrT69BHozzVhmUH87y8?=
 =?us-ascii?Q?jIfx1RMlzmb7mmybMRwJRl0dihQijL21Q21pbOu1gUjqk0DFh7jKbupZ8Sjg?=
 =?us-ascii?Q?00E/iOxrt1/c/7iMqDd15Or2RhmmscswYij1tQ+RDWpxmQATI8LHhZgkEyPO?=
 =?us-ascii?Q?1QcyZcd38ijQlfZllZUcsKz3VxCShyfAO+yfqzZ4TgIB+lzaNpxtGDNOap2F?=
 =?us-ascii?Q?YzfcNctjq3Rx6Q9L/xo67YHnLWFRXjP+xZjYuOgQq9ZP0cW1DlwB5TGmlS7X?=
 =?us-ascii?Q?wm0cvcFdGq9zLL/FNuhkLgAIuo7bPkgsw1qZ+HSG2csIfGToKBeYmsXKD2/4?=
 =?us-ascii?Q?gk86HUINU8dkQxXIOhvUKpKyLJO4qKj6gocTbGq0WgmE5ASeYlqQSXNQ5Aqt?=
 =?us-ascii?Q?NHH23YQSYLMM/Jf8MyBiEKf/b8eksdQW0TVkuVx5XlGIPtZmM4VRg9+H/EHx?=
 =?us-ascii?Q?2mhBf7b+w1H1vw5ompUlKN8cSivAiFo59BtKGY+K+oPgCCKMLFTpo3wjChTZ?=
 =?us-ascii?Q?uzv3dOUWLLQKgCGdMJJV48188ocwuvpGDWcLHB7G8cKJJG+BXzLL8D4Q2ORe?=
 =?us-ascii?Q?9pa6g57l65dCkUwyCDE8GU4r0gEigJ3Ncu32yWqNnSRGFRt1VPtJU3OdSC0+?=
 =?us-ascii?Q?WevU0t6kfuUK9vBubRpDCyUJa1FLB0BeIxF7ew/70nBeNtER9Aw0dZ1Us+pb?=
 =?us-ascii?Q?mrMbhqK2B+a1Hsser0NdTWkFoDNs0tfFimS42mPFlyaHjEDTjOu3sypuLKHh?=
 =?us-ascii?Q?uQqdIgUnvStUq9fZ4SAKfs3y+D6U9JHGK8cTRDOMu09e4Mqg+DNRrlDAUJG2?=
 =?us-ascii?Q?F8NBib35vo6riCkiA52aebSgdDmpLnWtM8rdqWiNrK9kCwTLxNxWC6K0z9kY?=
 =?us-ascii?Q?HqpkI4FClT3GgKjotdV5QvvRclK6eW4zR25wDdj/qAv6Ir5n7ZCwz/ngQ1Nq?=
 =?us-ascii?Q?1Xm9xgCOm7pwc6dlXnCvFbQt4qDZgxM3XOUqtHY+GZ8cEuhvaQtwwuRF7d7X?=
 =?us-ascii?Q?due5rsY9ZIF+pjsvLmmvZ8IMU0hbCt0GSSCbOvh9YT1G8nZU8VVns+ZPULvm?=
 =?us-ascii?Q?1E/iWMoWSInfC3J7LcM5tG3AcOa7ENrIPFqQztyQ9r6PZKctpqqaJSbvgaR6?=
 =?us-ascii?Q?AMMMM6B+ZUDi9NiBH54z1d/naYNZ/My3YSr5fuFd+cY/l9nDNs7cfzltwlE?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73de9c30-0fa5-42c1-15cd-08db866e8b6d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 02:35:55.0304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch only add the code of init and exit of lazy_tscdeadline.
The initialization of lazy tscdeadline is only invoked when guest
write specific msr and does following things:
 - map the GVA of struct kvm_lazy_tscdeadline to HVA of kernel side.
 - get one reference of the page

We assume the page of kvm_lazy_tscdeadline of guest won't be changed.
If the vcpu is reboot in normal or abnormal way, exit path will put
the page and unmmap it. This is archived by covering following path:
 - clear msr of lazy_tscdeadline, for normal reboot case
 - lapic reset, for abnormal reboot case
 - vcpu destroy, for the case that guest is gone

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/lapic.c            | 45 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/lapic.h            |  3 +++
 arch/x86/kvm/x86.c              | 13 +++++++++++-
 4 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 439e4a7..b036874 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -715,6 +715,9 @@ struct kvm_queued_exception {
 
 struct kvm_host_lazy_tscdeadline {
 	u64 msr_val;
+	u64 cached_armed;
+	struct page *page;
+	struct kvm_lazy_tscdeadline *guest;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 113ca96..71da41e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1676,6 +1676,50 @@ static int apic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	return 0;
 }
 
+int kvm_lazy_tscdeadline_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct page *page;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	void *hva;
+	u64 msr;
+
+	slots = kvm_memslots(vcpu->kvm);
+	msr = vcpu->arch.lazy_tscdeadline.msr_val;
+	gfn = msr >> PAGE_SHIFT;
+	slot = __gfn_to_memslot(slots, gfn);
+	pfn = gfn_to_pfn_memslot(slot, gfn);
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	page = pfn_to_page(pfn);
+	hva = kmap(page);
+	if (!hva)
+		return -EFAULT;
+
+	hva += offset_in_page(msr - KVM_MSR_ENABLED);
+	get_page(page);
+	vcpu->arch.lazy_tscdeadline.page = page;
+	vcpu->arch.lazy_tscdeadline.guest = hva;
+
+	return 0;
+}
+
+void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.lazy_tscdeadline.page) {
+		kunmap((void *)vcpu->arch.lazy_tscdeadline.guest);
+		put_page(vcpu->arch.lazy_tscdeadline.page);
+	}
+
+	vcpu->arch.lazy_tscdeadline.cached_armed = 0;
+	vcpu->arch.lazy_tscdeadline.page = NULL;
+	vcpu->arch.lazy_tscdeadline.guest = NULL;
+}
+
 static void update_divide_count(struct kvm_lapic *apic)
 {
 	u32 tmp1, tmp2, tdcr;
@@ -2652,6 +2696,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	/* Stop the timer in case it's a reset to an active apic */
 	hrtimer_cancel(&apic->lapic_timer.timer);
+	kvm_lazy_tscdeadline_exit(vcpu);
 
 	/* The xAPIC ID is set at RESET even if the APIC was already enabled. */
 	if (!init_event)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b..51b9d5b 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -278,4 +278,7 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
 
+int kvm_lazy_tscdeadline_init(struct kvm_vcpu *vcpu);
+void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dbbae8f..7225fc9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3878,7 +3878,16 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_LAZY_TSCDEADLINE))
 			return 1;
 
-		vcpu->arch.lazy_tscdeadline.msr_val = data;
+		if (!(data & KVM_MSR_ENABLED)) {
+			kvm_lazy_tscdeadline_exit(vcpu);
+		} else {
+			kvm_lazy_tscdeadline_exit(vcpu);
+			vcpu->arch.lazy_tscdeadline.msr_val = data;
+			if (kvm_lazy_tscdeadline_init(vcpu)) {
+				vcpu->arch.lazy_tscdeadline.msr_val = 0;
+				return 1;
+			}
+		}
 
 		break;
 	case MSR_IA32_MCG_CTL:
@@ -11964,6 +11973,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
+	kvm_lazy_tscdeadline_exit(vcpu);
+
 	static_call(kvm_x86_vcpu_free)(vcpu);
 
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
-- 
2.7.4

