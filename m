Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AFE1C3B01
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 15:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEDNMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 09:12:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23731 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726351AbgEDNMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 09:12:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588597960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3UJFfbQE2y0YksHkyDVD2IwXDk0FmannGZsgQWHPWN4=;
        b=Jow5aUhXFqee+eRcLAMAq5UETuixmXyqgHdu0QoEA0c8k2lcBo+oPyLmJKRT2js51czopQ
        yD8ipq1zGqit6OBYddqhfNGlIItTfE4QF8Z5+RVSaKTW5ZBuEKKzkeTao/LKkJQx4A18Oq
        Bp0sYTS1xWIhBwAAjp2I3hadlLHfKEE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-E7kuZ3EmPGWLYYrqR-ZpKw-1; Mon, 04 May 2020 09:12:39 -0400
X-MC-Unique: E7kuZ3EmPGWLYYrqR-ZpKw-1
Received: by mail-wr1-f70.google.com with SMTP id o8so10668948wrm.11
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 06:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3UJFfbQE2y0YksHkyDVD2IwXDk0FmannGZsgQWHPWN4=;
        b=hqrpxJkWf5CNKVKKrBvhJ/2V1AAQ25wM2owF98AqDWQdcir6w8AeB3x+VkWB1U6/Fi
         I/Gslkdnn4d5FcOmqvQTAYxpQ9EW1hL0HDEc23tV/sczyGpOg+z4rYP7TPC8XevMzQyn
         ZL5/gaBDo0zKyQAbsOkspLfCfEXF7w+Zfiyzn4dO3N6g3rvzh2hXTQia8D/lDasnnIdB
         6lIPBJzgDetZW2w1WXExgiekYlHo1Q1+e/o+fqH26zYNJJvWyo1ZvMkyPEf84KQ7Z6tW
         02AD5R4mMD/XwqBlcvDVhG+/LTI4d5fs+ubSql4dmWjMl/DrQWg9I5qerEe8aMt4t2K0
         +lpA==
X-Gm-Message-State: AGi0PubkGF/lLMlDs4rmRhYYH/oAyhXANgz1oa9tBLb4otRkgVmblOSY
        47vP6kIt35fQO1xuPuQU3lrBHflewLiPALqDOCjzJ1wuSgHPSRgA4H8x+fuY0MDXbbZF2TVocek
        n7+V+zZo6W39N
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr20588286wru.326.1588597957907;
        Mon, 04 May 2020 06:12:37 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ1O81/J0JwkiZSh7+3W4ruk62C2ztVK4Zj9/OJqN1Gg3ctJQj8c3Zb9XuibDPMugA0aCXfZw==
X-Received: by 2002:a5d:6a04:: with SMTP id m4mr20588269wru.326.1588597957696;
        Mon, 04 May 2020 06:12:37 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id h16sm20691024wrw.36.2020.05.04.06.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 06:12:37 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: nVMX: Skip IBPB when switching between vmcs01 and
 vmcs02
To:     Alexander Graf <graf@amazon.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        KarimAllah Raslan <karahmed@amazon.de>
References: <20200501163117.4655-1-sean.j.christopherson@intel.com>
 <1de7b016-8bc9-23d4-7f8b-145c30d7e58a@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d0d09da-3920-16d6-11ae-51b864171b66@redhat.com>
Date:   Mon, 4 May 2020 15:12:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1de7b016-8bc9-23d4-7f8b-145c30d7e58a@amazon.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/20 14:01, Alexander Graf wrote:
> I like the WARN_ON :). It should be almost free during execution, but
> helps us catch problems early.

Yes, it's nice.  I didn't mind the "buddy" argument either, but if we're 
going to get a bool I prefer positive logic so I'd like to squash this:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b57420f3dd8f..299393750a18 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -304,7 +304,13 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	prev = vmx->loaded_vmcs;
 	WARN_ON_ONCE(prev->cpu != cpu || prev->vmcs != per_cpu(current_vmcs, cpu));
 	vmx->loaded_vmcs = vmcs;
-	vmx_vcpu_load_vmcs(vcpu, cpu, true);
+
+	/*
+	 * This is the same guest from our point of view, so no
+	 * indirect branch prediction barrier is needed.  The L1
+	 * guest can protect itself with retpolines, IBPB or IBRS.
+	 */
+	vmx_vcpu_load_vmcs(vcpu, cpu, false);
 	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 669e14947ba9..0f9c8d2dd7f6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1311,7 +1311,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		pi_set_on(pi_desc);
 }
 
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_switch)
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool need_ibpb)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool already_loaded = vmx->loaded_vmcs->cpu == cpu;
@@ -1336,7 +1336,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_switch)
 	if (per_cpu(current_vmcs, cpu) != vmx->loaded_vmcs->vmcs) {
 		per_cpu(current_vmcs, cpu) = vmx->loaded_vmcs->vmcs;
 		vmcs_load(vmx->loaded_vmcs->vmcs);
-		if (!nested_switch)
+		if (need_ibpb)
 			indirect_branch_prediction_barrier();
 	}
 
@@ -1378,7 +1378,7 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	vmx_vcpu_load_vmcs(vcpu, cpu, false);
+	vmx_vcpu_load_vmcs(vcpu, cpu, true);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index fa61dc802183..e584ee9b3e94 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -320,7 +320,7 @@ struct kvm_vmx {
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
-void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool nested_switch);
+void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu, bool need_ibpb);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);


Paolo

