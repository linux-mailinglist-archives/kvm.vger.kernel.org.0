Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83582601C35
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 00:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJQWRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 18:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJQWRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 18:17:52 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D746C94F
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 15:17:50 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d24so12062684pls.4
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 15:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TrR1U1OdGGBTNU+L/j5+q/HQQR5gcpgDZtfvTOOBt0M=;
        b=Pa9UF6Hi2q1b744+/zFgnMjVA7j2pgI5ymLqfYIjscYUAYCF5ZXYRaOr8OH7B7Xd9F
         /HznXiV0rMC5mH6t0PX9UTIUMnvfTMra5P8j8/Err3N0tWueZMfcGzGtxNdF72RRSt7o
         NHpkNbOoj5ABhkcBEje6If6JGJVChr/yUqpTjUi6oHUQYtvQcn2Qq0A0mMJRwm7jwCpU
         txbpSRtq6Deb3lMYIB2V2HXjwUD/dBV3FD8oYF4YSQczKnAO+mdCYqOZu/+92E+l+c3z
         qnP5v2XAfcbbMH4rprLDtpkgxOqarwr2vDP6sOEKWp3p6bnA4ZtbMgRsXFz+JSka9OPZ
         iKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TrR1U1OdGGBTNU+L/j5+q/HQQR5gcpgDZtfvTOOBt0M=;
        b=l6KPZ37u8wXHqNUA4rVMsHwnRFGVWNtEmTvF9z6eY3uaqWEBgx2j/UYluGznSs167s
         1cq/OGZ7bKJyLsrssOLORYLVAyDd2M7oKYY15N969Xja414XPZggJ4Q6vd3+YkBUDM9e
         tymNsTQTx5PuSI/iP52PLyWG1A3aB2rLHG7gbfr5OcjOQDDhAYEhULSeBewBl6Ef9eqf
         p2PNiGOczyt4FbZ4Umn0X/yTbISB+2eeFDiP+9SJn58SmgwTJKadwY8+vb2pZmSy0LO4
         Rk9V8b2LsXEq4svmjGEFPlf/O2TJK7lHRHexEwdHgGO2gNzvPu/owXBMvATGzYGUX75F
         bAjw==
X-Gm-Message-State: ACrzQf3vnWRLIutZ/JN4P29Q1bAf1p1RUgvQL9zi3X9BVWYfsxl8JlWm
        e82sB5SoWIJP4r4K2+Kak6Nrmg==
X-Google-Smtp-Source: AMsMyM5sOws5M1E82UjbITIFno8w/HG4mdjtUwGqdWDsxnzcg+d5uvozuCFcCUl9QhNTIh10tM+Etg==
X-Received: by 2002:a17:903:1c2:b0:185:47ce:f4d2 with SMTP id e2-20020a17090301c200b0018547cef4d2mr14097565plh.101.1666045069741;
        Mon, 17 Oct 2022 15:17:49 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p13-20020a17090a74cd00b0020ad46d277bsm9992889pjl.42.2022.10.17.15.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 15:17:49 -0700 (PDT)
Date:   Mon, 17 Oct 2022 22:17:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com, aarcange@redhat.com,
        ddutile@redhat.com, dhildenb@redhat.com,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>, wei.w.wang@intel.com
Subject: Re: [PATCH v8 5/8] KVM: Register/unregister the guest private memory
 regions
Message-ID: <Y03UiYYioV+FQIpx@google.com>
References: <20220915142913.2213336-1-chao.p.peng@linux.intel.com>
 <20220915142913.2213336-6-chao.p.peng@linux.intel.com>
 <CA+EHjTxukqBfaN6D+rPOiX83zkGknHEQ16J0k6GQSdL_-e9C6g@mail.gmail.com>
 <20221012023516.GA3218049@chaop.bj.intel.com>
 <CA+EHjTyGyGL+ox81=jdtoHERtHPV=P7wJub=3j7chdijyq-AgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyGyGL+ox81=jdtoHERtHPV=P7wJub=3j7chdijyq-AgA@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022, Fuad Tabba wrote:
> Hi,
> 
> > > > +#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
> > > > +#define KVM_MEM_ATTR_SHARED    0x0001
> > > > +static int kvm_vm_ioctl_set_mem_attr(struct kvm *kvm, gpa_t gpa, gpa_t size,
> > > > +                                    bool is_private)
> > > > +{
> > >
> > > I wonder if this ioctl should be implemented as an arch-specific
> > > ioctl. In this patch it performs some actions that pKVM might not need
> > > or might want to do differently.
> >
> > I think it's doable. We can provide the mem_attr_array kind thing in
> > common code and let arch code decide to use it or not. Currently
> > mem_attr_array is defined in the struct kvm, if those bytes are
> > unnecessary for pKVM it can even be moved to arch definition, but that
> > also loses the potential code sharing for confidential usages in other
> > non-architectures, e.g. if ARM also supports such usage. Or it can be
> > provided through a different CONFIG_ instead of
> > CONFIG_HAVE_KVM_PRIVATE_MEM.
> 
> This sounds good. Thank you.

I like the idea of a separate Kconfig, e.g. CONFIG_KVM_GENERIC_PRIVATE_MEM or
something.  I highly doubt there will be any non-x86 users for multiple years,
if ever, but it would allow testing the private memory stuff on ARM (and any other
non-x86 arch) without needing full pKVM support and with only minor KVM
modifications, e.g. the x86 support[*] to test UPM without TDX is shaping up to be
trivial.

[*] https://lore.kernel.org/all/Y0mu1FKugNQG5T8K@google.com
