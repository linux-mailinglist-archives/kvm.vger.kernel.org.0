Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6E17E404
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgCIPwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:52:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41066 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727202AbgCIPwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 11:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583769159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpdJ6Cg1tIsPQIU8l639Qlh3t2/IFpSBkTvWUWG8TI0=;
        b=dkb0iEEkKkIDWuo2ZvLGLm1Co03rJZFT6xlJJv0O1UqvUdCRQWwbGF5bq5RfE6wZtO3KbP
        VAROzTBx4DjCUMVfXnm3wWtgsN415OCf609jsHnqpq/I/Tbkt5QNAiATsXeLZwOxdEJr8Z
        Hb+F8m8dQxvTjAtreNvPafZ2lD6SQWY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-5tpYYNb_PbqstWxIyZKFfQ-1; Mon, 09 Mar 2020 11:52:35 -0400
X-MC-Unique: 5tpYYNb_PbqstWxIyZKFfQ-1
Received: by mail-wr1-f70.google.com with SMTP id p11so5383638wrn.10
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 08:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpdJ6Cg1tIsPQIU8l639Qlh3t2/IFpSBkTvWUWG8TI0=;
        b=Sw3wcV0wMZ+tuKUb8RjSmOB/nTwF8DTfwoRnPLoYUqcM9XS0vyTt8sFm5+pBI8J25Z
         mCSfBRvr0Cwn1q9IDE/j/5ugM8z8Qqs6qd7Y7XWNWt3rlZ94pNtH70WkO4WgquZTlKDN
         Rd04cG8pN6HBVRodTsCyU0rhJiTwxVpcxSs/FBJagIXGWlSxf79YnZMZC2PTFpmQIEos
         SDDnLUgf6BGVU1+hhRw7Bof5VVQayYjUK1p0vCMKx/LdEz17Xs3tDf+gPxVVBb0PkGo7
         uyp1uRISLaMGq2SOj+sHA7vcZHNiQKgMc9+O0M9OpQ9oUCxM2QWCmjjy2esXI661FJvt
         971Q==
X-Gm-Message-State: ANhLgQ1d6IQThBZ+P7Zhdlfs2CLroto5oJtSr7Lti2AQyJ6Ax04OStbz
        k/tYYH1Ef52k1phTjS85LCGCK1/t+gCu+0ha+9utSpyq2fr+x71RRfCfCEsaFVJ38PQ8DACzMzG
        Re3ugH7Li1Qwo
X-Received: by 2002:a1c:9d41:: with SMTP id g62mr19391296wme.131.1583769154409;
        Mon, 09 Mar 2020 08:52:34 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vucLw7YOCnn8HRRRJAIb3+rjAedSA1dvQR96Or6tajfe9jl5CymLzC/u8rLXBoNjwCxXzD9vw==
X-Received: by 2002:a1c:9d41:: with SMTP id g62mr19391282wme.131.1583769154229;
        Mon, 09 Mar 2020 08:52:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q4sm17294521wro.56.2020.03.09.08.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:52:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 6/6] KVM: selftests: enlightened VMPTRLD with an incorrect GPA
Date:   Mon,  9 Mar 2020 16:52:16 +0100
Message-Id: <20200309155216.204752-7-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309155216.204752-1-vkuznets@redhat.com>
References: <20200309155216.204752-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that guest doesn't hang when an invalid eVMCS GPA is specified.
Testing that #UD is injected would probably be better but selftests lack
the infrastructure currently.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/x86_64/evmcs_test.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 10e9c158dc96..fed8f933748b 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -72,6 +72,10 @@ void guest_code(struct vmx_pages *vmx_pages)
 		l1_guest_code(vmx_pages);
 
 	GUEST_DONE();
+
+	/* Try enlightened vmptrld with an incorrect GPA */
+	evmcs_vmptrld(0xdeadbeef, vmx_pages->enlightened_vmcs);
+	GUEST_ASSERT(vmlaunch());
 }
 
 int main(int argc, char *argv[])
@@ -120,7 +124,7 @@ int main(int argc, char *argv[])
 		case UCALL_SYNC:
 			break;
 		case UCALL_DONE:
-			goto done;
+			goto part1_done;
 		default:
 			TEST_ASSERT(false, "Unknown ucall 0x%x.", uc.cmd);
 		}
@@ -152,6 +156,10 @@ int main(int argc, char *argv[])
 			    (ulong) regs2.rdi, (ulong) regs2.rsi);
 	}
 
-done:
+part1_done:
+	_vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_SHUTDOWN,
+		    "Unexpected successful VMEnter with invalid eVMCS pointer!");
+
 	kvm_vm_free(vm);
 }
-- 
2.24.1

