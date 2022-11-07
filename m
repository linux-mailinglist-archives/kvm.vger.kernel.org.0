Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3276761F725
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 16:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiKGPG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 10:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbiKGPG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 10:06:56 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D982D14034
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 07:06:55 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id g62so10861157pfb.10
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 07:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4jFCPlwpZWg2Kjtokjyu7cu6qRmEgh93f73kVu+XEs=;
        b=oetFNYCegdWD6vOJl36CdI66m/Wa0Uf+gSJkovRd88RWPXZj123nsB23AcVtywVBBz
         8HnLArsVb1sUWBGrLHq8O4Hn1sQFwfM+MQI/ycQXMdUM+pUr5MhW7STxzPEA6h8p0OYK
         XCAfu2pwVTPtaUcYKrSCfzzPtucZamwvuzDOcX/8mC8z6wDQWEc8RnSQdlcve05CQhgz
         3QF4WlvR/vZC69/xcvSAwSnYTGZhbS7OgWTy+N6e0juLxMzhPQN2TO6NQKhwrniOsraQ
         0/+7gf10khshzbB/90u4EAJsgz1PDu7DAs7QqO0m9OsDdw/F4Zua4DDq+U+JO4eYCPNE
         ZEkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4jFCPlwpZWg2Kjtokjyu7cu6qRmEgh93f73kVu+XEs=;
        b=sjcLwQUE973NmBNtxUR30w4WdVSlJQD2uu8efXh5N0WYS9al9tKwRSSFnVJIzUZdwg
         WfbJsfQXx4AOHfexdcf/dV15b+PcOvf3OkjMDR7kj2D+x19agOt0cqQnZFDKYwYQ7yBK
         vIUsMNvgVx6h8sbhDt1lftDfhjOqmxWQLs3/WON7ZkMEaJZ7CWhlTHG8ZHf8UN/bXgVA
         q4QrzyNfZV2f2H6jhdRbQJtdUUneWRQ0sydUETjtKNpgf84L+GdGGzsMtsP0TuP1b7Qv
         /Gr+JUf/iLBcXfN+3H8ccBbyNQMwW38beLH1rvTduvh1f8GLgnft+plknagaZ66QGmrM
         Q/kA==
X-Gm-Message-State: ACrzQf0NFhdMWBpvbtljcj+dxIb9HpzsjIozAn+5nGKxwkJ06B4cDcVQ
        R2NfPxJCIGbR5oXJoxe2/xUlCA==
X-Google-Smtp-Source: AMsMyM5S/bTupKKgF+m6qOP/1+9mSgDI9jP26DahKisXxNdbwDRBrv3AcUrPk3gr2d90F42F6T0Vkw==
X-Received: by 2002:a63:cf4e:0:b0:470:3be8:4d5f with SMTP id b14-20020a63cf4e000000b004703be84d5fmr13875271pgj.269.1667833615172;
        Mon, 07 Nov 2022 07:06:55 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k9-20020a17090a3cc900b00212d9a06edcsm6196927pjd.42.2022.11.07.07.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 07:06:54 -0800 (PST)
Date:   Mon, 7 Nov 2022 15:06:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Li <ercli@ucdavis.edu>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Liu Jingqi <jingqi.liu@intel.com>
Subject: Re: [PATCH v5 05/15] KVM: nVMX: Let userspace set nVMX MSR to any
 _host_ supported value
Message-ID: <Y2kfCz02tQSUkMKS@google.com>
References: <20220607213604.3346000-1-seanjc@google.com>
 <20220607213604.3346000-6-seanjc@google.com>
 <20221031163907.w64vyg5twzvv2nho@linux.intel.com>
 <Y2ABrnRzg729ZZNI@google.com>
 <20221101101801.zxcjswoesg2gltri@linux.intel.com>
 <Y2FePYteNrEfZ7D5@google.com>
 <20221102085414.fk2xss74jvtzs6mr@linux.intel.com>
 <Y2Px90RQydMUoiRH@google.com>
 <20221107082714.fq3sw7qii4unlcn2@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107082714.fq3sw7qii4unlcn2@linux.intel.com>
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

On Mon, Nov 07, 2022, Yu Zhang wrote:
> On Thu, Nov 03, 2022 at 04:53:11PM +0000, Sean Christopherson wrote:
> > Ideally, KVM should NEVER manipulate VMX MSRs in response to guest CPUID changes.
> > That's what I was referring to earlier by commits:

...

> Thanks Sean. Let me try to rephrase my understandings of your statement(
> and pls feel free to correct me):
> 
> 1> For now, what vmx_adjust_secondary_exec_control() does, is to enable/
> disable a feature in VMX MSR(and nVMX MSR) based on cpuid changes.
> 2> What makes sense is, if a feature is 
> 	a. disabled by guest CPUID, it shall not be exposed in guest VMX MSR;
> 	b. enabled by guest CPUID, it could be either exposed or hidden in
> 	guest VMX MSR.
> 3> So your previous change is to guarantee 2.a, and userspace VMM can choose
> to follow follow either choices in 2.b(depending on whether it believes this
> feature is correctly supported by KVM in nested). 
> 
> Is above understanding correct? 

Not quite.  Again, in an ideal world, KVM would not modify the VMX MSRs based on
guest CPUID.  But it's possible userspace is relying on KVM to hide a feature from
L2 if it's hidden from L1, so to avoid breaking an otherwise valide userspace config,
it's worth enforcing that in KVM.

> But what if userspace VMM sets guest CPUID first, disabling a feature, and
> then sets the guest VMX MSR bit with this feature enabled? Does KVM need to
> check guest CPUID again, in vmx_restore_control_msr()? 

No.  It's not KVM's responsibility to provide a sane, valid vCPU model.  So long
as KVM is not endangered by a bad config, userspace can do whatever it wants.
