Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B70629D7C
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 16:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbiKOPbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 10:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiKOPak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 10:30:40 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EB62E693
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 07:29:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso14171697pjc.2
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 07:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4xFPX3Z7GbW6bSnkxtp2PrmHn+B1TCPh3wtXpJcmJcQ=;
        b=TUQVrky3j7PjthGvLv0MpsXChKErxo0kKVDc9vuozjGFAup0y/4rCu/Lzwz6ct6fZs
         BNbGBoq4egydzZT1XD5G9Iw8nW/X04QBH7tE+4COvPwIa4SaJ1nuLtmpI036IMcToeGW
         zZnGcx9sd4VGScYiYLy1OyEYKFwVDwbrkUsnNS4hFLF526AyUnyzMaNnHmNZcPZDfW7D
         e0pMO2Uq6fHZ07WS/cFVVNICW//s8pxLGd0l36DhNuW1FMCWfklfG7mJQ6xjl4w9vKHV
         TBG1TIXD1HoE37MGmdbRI15hUh4DH458Ms8kuR0sBB2a++VU0E+TYvMCouvgxHIFkkn2
         8thw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xFPX3Z7GbW6bSnkxtp2PrmHn+B1TCPh3wtXpJcmJcQ=;
        b=2iv5dbzuPyEQY65QkVceDT60RSv1JYXpnPMkC0SLI+DWaE+fAzQutVcc3n9u+F/y7j
         SbFZfY8sROhUh2GAlK9iYird6SrYI/ApCdK1KfPtwQau/ovFGuMrEW5Mh0rpK1RwzJ/u
         /UCP3CxvI+xOO4juSqyX3RjByuodIe+WEV2YDPpi1xsT+lBV+QOJcxNcSwXcrh5PmHRX
         JUBFNQPzdd+ts1hlMO2Nmx4eaFXAB9Rl/A7nbstIkOR9mW7Ss7/uYfQIsmkTyJCFS8FG
         QZ2cdGrU7QdxmsoJ+QSyJKJ+r37DRX+DkdbteLxeSyTVq3hql+2v84UutF0d3b/6OWNx
         wr1A==
X-Gm-Message-State: ANoB5pmbrkq53TmSNTeXxc1L6n7QCXK8UDkpYCP6OtuYn3PXVoql9I6o
        CrGZ1JFdKWpoFGPJawobkGzkKQ==
X-Google-Smtp-Source: AA0mqf58kcbUcqreW0oERfBqZonqX7Aj1FkzaTQ3Wu++37yoKgQX6Z6ovOLD54LrZlViN1l9RXKR8A==
X-Received: by 2002:a17:90b:684:b0:212:ca89:41c9 with SMTP id m4-20020a17090b068400b00212ca8941c9mr2723275pjz.244.1668526188923;
        Tue, 15 Nov 2022 07:29:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902e74200b001869b988d93sm10093465plf.187.2022.11.15.07.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 07:29:48 -0800 (PST)
Date:   Tue, 15 Nov 2022 15:29:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] x86: KVM: Move existing x86 CPUID leaf
 [CPUID_7_1_EAX] to kvm-only leaf
Message-ID: <Y3OwaRBzVFqJ4KEs@google.com>
References: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
 <20221110015252.202566-2-jiaxi.chen@linux.intel.com>
 <f8607d23-afaa-2670-dd03-2ae8ec1e79a0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8607d23-afaa-2670-dd03-2ae8ec1e79a0@intel.com>
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

On Tue, Nov 15, 2022, Xiaoyao Li wrote:
> On 11/10/2022 9:52 AM, Jiaxi Chen wrote:
> > cpuid_leaf[12] CPUID_7_1_EAX has only two bits are in use currently:
> > 
> >   - AVX-VNNI CPUID.(EAX=7,ECX=1):EAX[bit 4]
> >   - AVX512-BF16 CPUID.(EAX=7,ECX=1):EAX[bit 5]
> > 
> > These two bits have no other kernel usages other than the guest
> > CPUID advertisement in KVM. Given that and to save space for kernel
> > feature bits, move these two bits to the kvm-only subleaves. The
> > existing leaf cpuid_leafs[12] is set to CPUID_LNX_5 so future feature
> > can pick it. This basically reverts:
> > 
> >   - commit b85a0425d805 ("Enumerate AVX Vector Neural Network
> > instructions")
> >   - commit b302e4b176d0 ("x86/cpufeatures: Enumerate the new AVX512
> > BFLOAT16 instructions")
> >   - commit 1085a6b585d7 ("KVM: Expose AVX_VNNI instruction to guset")
> 
> FYI, LAM support has been queued in tip https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=aa387b1b1e666cacffc0b7ac7e0949a68013b2d9
> 
> It adds
> 
> +#define X86_FEATURE_LAM			(12*32+26) /* Linear Address Masking */
> 
> and conflict with this patch.
> 
> Seen from the ISE, there are more bits defined in CPUID_7_1_EAX. And I
> believe Intel will define more and it's likely some of them will be used by
> kernel just like LAM.

Heh, are any of the bits you believe Intel will add publicly documented?  :-)

LAM could be scattered, but if more bits are expected that's probably a waste of
time and effort.

Thanks for the heads up!
