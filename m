Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1254E2309
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 10:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345721AbiCUJOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 05:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbiCUJOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 05:14:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15D1E22BE2
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 02:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647853986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ruVQAPQyVxSUmpWM0lWG0+oQ7BPZ/wSzpsVTqVtPuBE=;
        b=g5quEu2bdfKrfuMbghl2UOm1yqu2jrSOLuDirDVYyBoEjlMhK2f6F8sGX23r0bWdfYNTUZ
        ncVNc+yN72uAT3aRMLH9MgtEDdvhAGaul/wkSAU89YDdQZOe5A4EnHrpDBNvHc0PyJl0+K
        viGEauIU+Q3EVUsf6+aVNx+WxGCoock=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-UyUBBcZsPW2fz1Z3SsqPCQ-1; Mon, 21 Mar 2022 05:13:04 -0400
X-MC-Unique: UyUBBcZsPW2fz1Z3SsqPCQ-1
Received: by mail-ed1-f69.google.com with SMTP id cm27-20020a0564020c9b00b004137effc24bso8270920edb.10
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 02:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ruVQAPQyVxSUmpWM0lWG0+oQ7BPZ/wSzpsVTqVtPuBE=;
        b=vfeQXs857jff5rFrwvMAWVpO5xcwM+0q+LK53inc+kuIcoGu8uinydDxcfhACz102R
         nDgUltsQd8YhaMwL9O14rZxrrhxM0XNfNI+WpdiAcPAYIsL0o57LUt6BBuHgKBhaIFiv
         QodlQrCO+guJKG1fd6khwVEW+uKVGZZYPLJqKCoOOBdwWeK1uIkpvfyp+nn+8MBwKPcW
         o5CISxVl6UxTSR4/HTnlnkW38reCXO/LFdZQd4wiIHXCCGEzGvX7aZQP9L67IK0W/Qk+
         Dc+tSQ0eHiN6qND0YvjFY38k30+tr1m/obKnrZksAibkHRCkaeoBW4V1dNl3mMeiDLOE
         Lj4A==
X-Gm-Message-State: AOAM531/hmqn+5BMZ1w98jefPwmOQgLtIrlbhVAuYZBpqyVn/ZHSuLn7
        HunmlSH5/KKG9A3BjxdHwbXRiffLL2Y/1NdVWLR1cuOBXVCLF4tyK97RO2As6rK6qIAO9P2NffL
        GtnJu3K+oXZXr
X-Received: by 2002:a17:906:d204:b0:6d6:df17:835e with SMTP id w4-20020a170906d20400b006d6df17835emr19286327ejz.20.1647853982715;
        Mon, 21 Mar 2022 02:13:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwH+3MilHjpAinJ5SoKmOS0poHWTbX3aX4bmpLEON1uG5YV4WPNHhIc+ApRiUKf1wGjcov1jw==
X-Received: by 2002:a17:906:d204:b0:6d6:df17:835e with SMTP id w4-20020a170906d20400b006d6df17835emr19286311ejz.20.1647853982464;
        Mon, 21 Mar 2022 02:13:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id bw26-20020a170906c1da00b006c8aeca8febsm6647593ejb.47.2022.03.21.02.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 02:13:01 -0700 (PDT)
Message-ID: <d6367754-7782-7c29-e756-ac02dbd4520b@redhat.com>
Date:   Mon, 21 Mar 2022 10:13:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [FYI PATCH] Revert "KVM: x86/mmu: Zap only TDP MMU leafs in
 kvm_zap_gfn_range()"
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20220318164833.2745138-1-pbonzini@redhat.com>
In-Reply-To: <20220318164833.2745138-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/18/22 17:48, Paolo Bonzini wrote:
> This reverts commit cf3e26427c08ad9015956293ab389004ac6a338e.
> 
> Multi-vCPU Hyper-V guests started crashing randomly on boot with the
> latest kvm/queue and the problem can be bisected the problem to this
> particular patch. Basically, I'm not able to boot e.g. 16-vCPU guest
> successfully anymore. Both Intel and AMD seem to be affected. Reverting
> the commit saves the day.
> 
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

This is not enough, the following is also needed to account
for "KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow
pages":

------------------- 8< ----------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] kvm: x86/mmu: Flush TLB before zap_gfn_range releases RCU

Since "KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()"
is going to be reverted, it's not going to be true anymore that
the zap-page flow does not free any 'struct kvm_mmu_page'.  Introduce
an early flush before tdp_mmu_zap_leafs() returns, to preserve
bisectability.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index af60922906ef..7f63e1a704e3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -941,13 +941,17 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
  		flush = true;
  	}
  
+	/*
+	 * Need to flush before releasing RCU.  TODO: do it only if intermediate
+	 * page tables were zapped; there is no need to flush under RCU protection
+	 * if no 'struct kvm_mmu_page' is freed.
+	 */
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
+
  	rcu_read_unlock();
  
-	/*
-	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
-	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
-	 */
-	return flush;
+	return false;
  }
  
  /*

