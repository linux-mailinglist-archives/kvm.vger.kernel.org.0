Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41664514CB7
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377224AbiD2O2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbiD2O17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:27:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0D991358
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:24:40 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e24so7276461pjt.2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7tC/JKOk9L0c4P3431GOxph3zjvk5J8dJFmkqVAnJxc=;
        b=F0+Y3mMT0AqdA2ZfjnbeDVfDmZPiiSQXRHQCLASaN7eLfv15TfF0iLNRdE6IOoeC/g
         6GkXEEBq0PSKDjB2LJstij0jmH99SMZXxtjVbtiDjgY2vdjLCU+EE5SoMc5FV4TR9tG5
         ehRV+g9B5kQNJtwCJEoRKDuSMT/SV+oYmWMEAUsVtFJnPTYB5/qUX4MBdp8WlNfn0fyB
         3ld1a7DlYAa61TIpVQunTEelniygDy9n7MOGhFEb2bhWuoZunIZEfAgiXofhJWVX062S
         EB3po2+BTr4QWUV/PcCKFE/2uDBMP2pS/prgXU/+a7qr9JylszfvPmOveqX8gGS0sCOs
         qOzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7tC/JKOk9L0c4P3431GOxph3zjvk5J8dJFmkqVAnJxc=;
        b=wQmWx20CFGAemUkCejZ4O3C/rFrEAAxCLxUpk3Fqkc3/rCN42gz+DP0TL8VMeRs0ZU
         p91EGwORi2sTJtSMSwg7kyRuubG5M7/aumsP0+ZLPoy41UHJh75J0z2AOP/yFU52vIu8
         MlU6/X+XeYXfUf3U0bWxY8lJSw/Op33csPpvrPeIPozvnSh3fr54MAGL4Y9dSrgvJL9l
         d7qqxszKwsje0UN1KEYmcuVkJacz2mXBeCu0c2eFUI3ymr2C07Gdm68AU3iQuqWyDcqF
         Kv6PotnI2QUmAwOWrBkgKoX5LS1HxrDln0Xc4q4CN9FhbX9kuQAysUUdaKbv+63rVLn0
         xGRg==
X-Gm-Message-State: AOAM530iBWxtA1UGdkdbeC+UzgMOKNBzvollujOjLPKcdbhNXPR9zJzl
        IauzOJO3l5iayf0iLRMxlGqDXQ==
X-Google-Smtp-Source: ABdhPJwedY/+Y+SN/KDf33mBRLNyBEObEHex1x/IqkMk86Yt4Fukf5wpBrFB7Bnr5BKAbNwLSzjrUA==
X-Received: by 2002:a17:902:e748:b0:15c:e3b9:bba3 with SMTP id p8-20020a170902e74800b0015ce3b9bba3mr33249235plf.139.1651242279947;
        Fri, 29 Apr 2022 07:24:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g17-20020a625211000000b005056a6313a7sm3168604pfb.87.2022.04.29.07.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 07:24:38 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:24:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR
Message-ID: <Ymv1I5ixX1+k8Nst@google.com>
References: <20220428233416.2446833-1-seanjc@google.com>
 <337332ca-835c-087c-c99b-92c35ea8dcd3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337332ca-835c-087c-c99b-92c35ea8dcd3@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022, Paolo Bonzini wrote:
> On 4/29/22 01:34, Sean Christopherson wrote:
> 
> > +static inline gfn_t kvm_mmu_max_gfn_host(void)
> > +{
> > +	/*
> > +	 * Disallow SPTEs (via memslots or cached MMIO) whose gfn would exceed
> > +	 * host.MAXPHYADDR.  Assuming KVM is running on bare metal, guest
> > +	 * accesses beyond host.MAXPHYADDR will hit a #PF(RSVD) and never hit
> > +	 * an EPT Violation/Misconfig / #NPF, and so KVM will never install a
> > +	 * SPTE for such addresses.  That doesn't hold true if KVM is running
> > +	 * as a VM itself, e.g. if the MAXPHYADDR KVM sees is less than
> > +	 * hardware's real MAXPHYADDR, but since KVM can't honor such behavior
> > +	 * on bare metal, disallow it entirely to simplify e.g. the TDP MMU.
> > +	 */
> > +	return (1ULL << (shadow_phys_bits - PAGE_SHIFT)) - 1;
> 
> The host.MAXPHYADDR however does not matter if EPT/NPT is not in use, because
> the shadow paging fault path can accept any gfn.

... 

> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index e6cae6f22683..dba275d323a7 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -65,6 +65,30 @@ static __always_inline u64 rsvd_bits(int s, int e)
>  	return ((2ULL << (e - s)) - 1) << s;
>  }
> +/*
> + * The number of non-reserved physical address bits irrespective of features
> + * that repurpose legal bits, e.g. MKTME.
> + */
> +extern u8 __read_mostly shadow_phys_bits;
> +
> +static inline gfn_t kvm_mmu_max_gfn(void)
> +{
> +	/*
> +	 * Note that this uses the host MAXPHYADDR, not the guest's.
> +	 * EPT/NPT cannot support GPAs that would exceed host.MAXPHYADDR;
> +	 * assuming KVM is running on bare metal, guest accesses beyond
> +	 * host.MAXPHYADDR will hit a #PF(RSVD) and never cause a vmexit
> +	 * (either EPT Violation/Misconfig or #NPF), and so KVM will never
> +	 * install a SPTE for such addresses.  If KVM is running as a VM
> +	 * itself, on the other hand, it might see a MAXPHYADDR that is less
> +	 * than hardware's real MAXPHYADDR.  Using the host MAXPHYADDR
> +	 * disallows such SPTEs entirely and simplifies the TDP MMU.
> +	 */
> +	int max_gpa_bits = likely(tdp_enabled) ? shadow_phys_bits : 52;

I don't love the divergent memslot behavior, but it's technically correct, so I
can't really argue.  Do we want to "officially" document the memslot behavior?

> +
> +	return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
> +}
> +
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
