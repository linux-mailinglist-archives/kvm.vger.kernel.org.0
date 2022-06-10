Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDBD546865
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 16:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349548AbiFJOeM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 10:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349550AbiFJOd6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 10:33:58 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5078013FBFF
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 07:33:16 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q12-20020a17090a304c00b001e2d4fb0eb4so2417547pjl.4
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 07:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PxR9OrMSrWpGfEqawpy3/wVuAkYaSeZlAnBh5KVMXJE=;
        b=NJbzSY3yJxO4M4StgBH/ADd+InJNwVt4O3UCjO1lmgKqqZoWakKAC4evwmHBWOT6DD
         ZXztB7rGawow2r4HA4er20ia0kLPCsu6l5vPb53g9jzV06R6FazDE00XpE4uBONTos35
         qpc+wlG9Ale+JvKoySfGLzKdmfZM/XSb9PomEoFCY4enp8ZUXSX0NMyJAB+WxM2+3sUk
         S6iFFlKOiNWC8b5gZJ+5p5+yKSbk+e1QjJpLpMZ15ikiAY91IrV5pzHCmN5B/gkn/aUf
         Mep+j/k2tWgjRuUV40mYcHHczhP8X+QCTXPVn9ZhnPz8A8g541OlmakI7DWfYvCl0o0F
         k2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PxR9OrMSrWpGfEqawpy3/wVuAkYaSeZlAnBh5KVMXJE=;
        b=lyjD8UCG6fErGAQ/2Sbu9GCPJiwmWg0LEa5TAewarkHZ+8nMeNoPBvc84540djNyUp
         U5aBZwaYUHX8X2ZK33mrqaemN1peYs7hMDI7/hpY2rseLXbfN39UdCP6pGe5El0RGma1
         A9C4dAX9MEQ6lcIPTEPXkKhJ18zS5x9BW4gA91aIaGhS9LHM/g2YNdd9JajARuEPMp86
         K7iQ09nsRr8g7jqxmmwDnYVzNcV/KE4Dlnr0TWzjssvmQVyKz+Rvv8oUrHWMAokCjeEg
         v89cCQpLF50Jy1/3yYZcOEe74AKPaI/j2K6nSR2FbsptuyN7QXk62dMM0USf+CaVJpXY
         4tmA==
X-Gm-Message-State: AOAM533Brmb/2pqNLQ5lA1zabY5Xn9SawJrLZGsVO3C/mwilHD8gHHxV
        NktJ8VwUiV5HQFBYT6LoybqsNw==
X-Google-Smtp-Source: ABdhPJz5794unjcLLHf76DTPX/t1FfZvxPtA+iJKJnZE7mgcdzh1ieHg0oZJuGEsiodfohqFec+KlQ==
X-Received: by 2002:a17:90b:3805:b0:1e6:85aa:51b with SMTP id mq5-20020a17090b380500b001e685aa051bmr70256pjb.182.1654871595529;
        Fri, 10 Jun 2022 07:33:15 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d9-20020a656b89000000b003fd7e217686sm11556105pgw.57.2022.06.10.07.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:33:14 -0700 (PDT)
Date:   Fri, 10 Jun 2022 14:33:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 126/144] KVM: selftests: Convert kvm_binary_stats_test
 away from vCPU IDs
Message-ID: <YqNWJwlGWleTw7sR@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-127-seanjc@google.com>
 <20220610104851.g2r6yzd6j22xod6m@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610104851.g2r6yzd6j22xod6m@gator>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 10, 2022, Andrew Jones wrote:
> On Fri, Jun 03, 2022 at 12:43:13AM +0000, Sean Christopherson wrote:
> > @@ -220,17 +221,21 @@ int main(int argc, char *argv[])
> >  	/* Create VMs and VCPUs */
> >  	vms = malloc(sizeof(vms[0]) * max_vm);
> >  	TEST_ASSERT(vms, "Allocate memory for storing VM pointers");
> > +
> > +	vcpus = malloc(sizeof(struct kvm_vcpu *) * max_vm * max_vcpu);
> > +	TEST_ASSERT(vcpus, "Allocate memory for storing vCPU pointers");
> > +
> >  	for (i = 0; i < max_vm; ++i) {
> >  		vms[i] = vm_create_barebones();
> >  		for (j = 0; j < max_vcpu; ++j)
> > -			__vm_vcpu_add(vms[i], j);
> > +			vcpus[j * max_vcpu + i] = __vm_vcpu_add(vms[i], j);
> 
> The expression for the index should be 'i * max_vcpu + j'. The swapped
> i,j usage isn't causing problems now because
> DEFAULT_NUM_VM == DEFAULT_NUM_VCPU, but that could change.

It's better to be lucky than good?

Thanks much, I appreciate the reviews!
