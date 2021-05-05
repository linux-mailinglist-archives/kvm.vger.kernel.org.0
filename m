Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEF7373F60
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 18:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhEEQRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 12:17:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233798AbhEEQRZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 12:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620231388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtoMXiwx/TZYh7+WehJVTMiOcQ29qIoOXNdluC//5Ro=;
        b=dJ69krHSNFCPdIIaX2vBr6rxRyqaE++hZ5wMp+pwTmVFEbvXppd3yNYFjq/PPV54LEQZSi
        mTzdYEYHIJ9+O7PT3NpFMNgkP8PIKtjLhEAJHPQJa6Qf5bK8Dh8COkcMQNLkzbTX3dHAQM
        Zo6bSmF0E4hOSs7G7cqDSTRAicWY8sk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-yh3T7oc5MsajVxkilSivLA-1; Wed, 05 May 2021 12:16:25 -0400
X-MC-Unique: yh3T7oc5MsajVxkilSivLA-1
Received: by mail-wm1-f72.google.com with SMTP id c2-20020a1cb3020000b029013850c82dbcso1763986wmf.5
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 09:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MtoMXiwx/TZYh7+WehJVTMiOcQ29qIoOXNdluC//5Ro=;
        b=K56vWFFS7lvBAiTRGRxhg8gnVPASDhjv/9e0RoNTQQIJhNTbK+EEtDzCLnu/cOj78F
         dOKz7MsGxvV5juVh0Emk4Y/RcjgBzpeuDRP8XBBCtKgf1UI2lTpnEuzKcg7ElTfXdebo
         mbzgaTqWboO6g8xE0aBUIxD48dXpEzaVEKamSfR29CQXS00aqo5uNFIx1sHTD3zKiyIr
         SkkAh2sWA/NhhM2ARLOmYtP2k8dAjO5AoGBwSw2Nd8MDCAn0gEdslRovTm03u0FAo0sK
         dyt0Ipg+qggT3wocT7PP6zcbnzfPV1UdCthwjbw65TradkLd4Z+3RCtSoDxVP5GwBTiE
         D3rQ==
X-Gm-Message-State: AOAM5337TTSarUEofZr6P/9u91h7yB4FpNqnsd+HIpExjyEZ3WRQLJGb
        2AmTlUwYCDYFbD+za3SHJ3SqrXYFVt8GRaV3rM5Q3EdIso4P9qjl2KWLfMw7yq5hqEJDTb7YRWj
        s3/oJz31o8MR6
X-Received: by 2002:a5d:660c:: with SMTP id n12mr39239347wru.87.1620231383052;
        Wed, 05 May 2021 09:16:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5wqdw3ZPs/Tvf3D2pZcdljN/vf1kRYOQ6+ZfxftfAS0raT4MWIQol7PDugizh2DuLUpInEA==
X-Received: by 2002:a5d:660c:: with SMTP id n12mr39239327wru.87.1620231382834;
        Wed, 05 May 2021 09:16:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s10sm3438995wru.55.2021.05.05.09.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 09:16:22 -0700 (PDT)
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        kvm list <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
References: <601f1278-17dd-7124-f328-b865447ca160@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: SRCU dereference check warning with SEV-ES
Message-ID: <c65e06ed-2bd8-cac9-a933-0117c99fc856@redhat.com>
Date:   Wed, 5 May 2021 18:16:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <601f1278-17dd-7124-f328-b865447ca160@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 16:01, Tom Lendacky wrote:
> Boris noticed the below warning when running an SEV-ES guest with
> CONFIG_PROVE_LOCKING=y.
> 
> The SRCU lock is released before invoking the vCPU run op where the SEV-ES
> support will unmap the GHCB. Is the proper thing to do here to take the
> SRCU lock around the call to kvm_vcpu_unmap() in this case? It does fix
> the issue, but I just want to be sure that I shouldn't, instead, be taking
> the memslot lock:

I would rather avoid having long-lived maps, as I am working on removing
them from the Intel code.  However, it seems to me that the GHCB is almost
not used after sev_handle_vmgexit returns?

If so, there's no need to keep it mapped until pre_sev_es_run:

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a9d8d6aafdb8..b2226a5e249d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2200,9 +2200,6 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
  
  static void pre_sev_es_run(struct vcpu_svm *svm)
  {
-	if (!svm->ghcb)
-		return;
-
  	if (svm->ghcb_sa_free) {
  		/*
  		 * The scratch area lives outside the GHCB, so there is a
@@ -2220,13 +2217,6 @@ static void pre_sev_es_run(struct vcpu_svm *svm)
  		svm->ghcb_sa = NULL;
  		svm->ghcb_sa_free = false;
  	}
-
-	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
-
-	sev_es_sync_to_ghcb(svm);
-
-	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
-	svm->ghcb = NULL;
  }
  
  void pre_sev_run(struct vcpu_svm *svm, int cpu)
@@ -2465,7 +2455,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
  
  	ret = sev_es_validate_vmgexit(svm);
  	if (ret)
-		return ret;
+		goto out_unmap;
  
  	sev_es_sync_from_ghcb(svm);
  	ghcb_set_sw_exit_info_1(ghcb, 0);
@@ -2485,6 +2485,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
  		ret = svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
  		break;
  	case SVM_VMGEXIT_AP_HLT_LOOP:
+		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
  		ret = kvm_emulate_ap_reset_hold(vcpu);
  		break;
  	case SVM_VMGEXIT_AP_JUMP_TABLE: {
@@ -2531,6 +2521,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
  		ret = svm_invoke_exit_handler(vcpu, exit_code);
  	}
  
+	sev_es_sync_to_ghcb(svm);
+
+out_unmap:
+	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
+	svm->ghcb = NULL;
  	return ret;
  }
  
@@ -2619,21 +2620,4 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
  
  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
  {
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	/* First SIPI: Use the values as initially set by the VMM */
-	if (!svm->received_first_sipi) {
-		svm->received_first_sipi = true;
-		return;
-	}
-
-	/*
-	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
-	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
-	 * non-zero value.
-	 */
-	if (!svm->ghcb)
-		return;
-
-	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
  }

However:

1) I admit I got lost in the maze starting with sev_es_string_io

2) upon an AP reset hold exit, the above patch sets the EXITINFO2 field
before the SIPI was received.  My understanding is that the processor will
not see the value anyway until it resumes execution, and why would other
vCPUs muck with the AP's GHCB.  But I'm not sure if it's okay.

Paolo

