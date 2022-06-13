Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77ADF549BFD
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbiFMSoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346503AbiFMSnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:43:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D1BCDFF40
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 08:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655133553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3qc0QHbg0bZf6soTJPhE10Cu+OctUiRDtPKplnACghU=;
        b=SGMR4uu6/0TI4AhoeN6hrbVTX4FR1USJAfrylW5n4OUKhh4YRKujcua59r0zb1aXK8LOLE
        tlyOBxbkgouXgI37d5BVh8iZVXlbPXnf56b8V7pv4AZEDBH8cPzXPDF12xL9GpAewH0q9M
        1oxxuvtClIs6mKij9dGa6g3cVPZBtV8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-xZTop62BMzyw0VG8rDy-sg-1; Mon, 13 Jun 2022 11:19:12 -0400
X-MC-Unique: xZTop62BMzyw0VG8rDy-sg-1
Received: by mail-qt1-f197.google.com with SMTP id r9-20020a05622a034900b00304ea5d41ddso4564183qtw.20
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 08:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=3qc0QHbg0bZf6soTJPhE10Cu+OctUiRDtPKplnACghU=;
        b=Xs7zcXeuoQKPN4jdPpOgqQCHZ74y6SCUn0n/psl3xbEoWfM0RrH2KDwE7ksD3CW/vV
         yHSQXJbGaRnUg81j6T/Q+4qHlrV3AR9Av8i6O8ScJghdYjv9o5bXxoFnbNh37/qH82VU
         UyMuJPTxg1AbGOAfa16qtYlYXVOFYfvca41hhYjEzlJyisjTodbZqcEdbMNN6vhkUjM2
         8VPW6TDeIoIg4q11L8x/YV5UgwzUqOIPKzTqQlF3LQBJuU6SlKTybfHQB5J/OHvmfumv
         kIhuWqCtbF3O8t2vU1JFCiovCZuQ5KFRcaaQ4YvWEAwudWj8hgJkDot4vPlfS1CMu1IT
         K/Yw==
X-Gm-Message-State: AJIora80wv1bL8VWwrS7IBa72r+OBPL8dARhRuXATWzRhwftzhLZuI3x
        CFt5S40k+11Fv655GK4tW+oDvhB05bfo8SFmcTJGpL7vcUR9p9UhdZvn1QLOL9bNuf3CIbw333H
        NJRME9ZMSK/2q
X-Received: by 2002:a05:6214:2b08:b0:464:6201:f795 with SMTP id jx8-20020a0562142b0800b004646201f795mr252773qvb.51.1655133551813;
        Mon, 13 Jun 2022 08:19:11 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t0M8DN7IV7tZriF1UHpnJwt4kR2pCCywkY5ZpI4MMFfal32LxCCY1uGlQO+TKCqXj0V7porw==
X-Received: by 2002:a05:6214:2b08:b0:464:6201:f795 with SMTP id jx8-20020a0562142b0800b004646201f795mr252747qvb.51.1655133551566;
        Mon, 13 Jun 2022 08:19:11 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z5-20020a05620a260500b006a3696c4739sm6767255qko.19.2022.06.13.08.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 08:19:10 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Kyle Meyer <kyle.meyer@hpe.com>
Cc:     russ.anderson@hpe.com, payton@hpe.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, seanjc@google.com,
        wanpengli@tencent.com, Kyle Meyer <kyle.meyer@hpe.com>,
        kvm@vger.kernel.org, x86@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] KVM: x86: Increase KVM_MAX_VCPUS to 2048
In-Reply-To: <20220613145022.183105-1-kyle.meyer@hpe.com>
References: <20220613145022.183105-1-kyle.meyer@hpe.com>
Date:   Mon, 13 Jun 2022 17:19:06 +0200
Message-ID: <878rq0k2vp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kyle Meyer <kyle.meyer@hpe.com> writes:

> Increase KVM_MAX_VCPUS to 2048 so we can run larger virtual machines.
>
> Notable changes:
>
> * KVM_CAP_MAX_VCPUS will return 2048.
> * KVM_MAX_VCPU_IDS will increase from 4096 to 8192.
> * KVM_HV_MAX_SPARSE_VCPU_SET_BITS will increase from 16 to 32.
>
> * CPUID[HYPERV_CPUID_IMPLEMENT_LIMITS (00x40000005)].EAX will now be 2048.
>
> * struct kvm will increase from 40336 B to 40464 B.
> * struct kvm_arch will increase from 34488 B to 34616 B.
> * struct kvm_ioapic will increase from 5240 B to 9848 B.
>
> * vcpu_mask in kvm_hv_flush_tlb will increase from 128 B to 256 B.
> * vcpu_mask in kvm_hv_send_ipi will increase from 128 B to 256 B.

FWIW, this one will go away when
https://lore.kernel.org/kvm/20220606083655.2014609-11-vkuznets@redhat.com/
lands.

> * vcpu_bitmap in ioapic_write_indirect will increase from 128 B to 256 B.
> * vp_bitmap in sparse_set_to_vcpu_mask will increase from 128 B to 256 B.

...

> * sparse_banks in kvm_hv_flush_tlb will increase from 128 B to 256 B.
> * sparse_banks in kvm_hv_send_ipi will increase from 128 B to 256 B.

and these two are going away with
https://lore.kernel.org/kvm/20220606083655.2014609-13-vkuznets@redhat.com/
(at the cost of growing 'struct kvm_vcpu_hv')

>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3a240a64ac68..58653c63899f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -38,7 +38,7 @@
>  
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  
> -#define KVM_MAX_VCPUS 1024
> +#define KVM_MAX_VCPUS 2048
>  
>  /*
>   * In x86, the VCPU ID corresponds to the APIC ID, and APIC IDs

-- 
Vitaly

