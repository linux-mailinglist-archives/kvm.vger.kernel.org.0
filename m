Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FF758803D
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbiHBQ20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237581AbiHBQ2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:28:20 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0893437F8E
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:28:19 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 12so12789237pga.1
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 09:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=m5JXOmTfBKNUXaoyaUbMC0qVBYGlHYto5nPX9Patf5M=;
        b=N3NHL+iPO2a8XKIjeTt0N8pPFLwVwZlbHqWt5VKUt27XsormudLJOb4NQoxPULnpGV
         S3Hfe5bmahuKbxOHGW5KmgZyIjQwUDkx2n913wEB3xVzIuCxS3z9twvBoYubojbCC7b9
         8dCkyh6jv3mhM4rYqRiQqahOfZaz/cgGCgetM9RwgLfjLbkNA+oOH/WAIY23L0HCjPak
         OxdK4wAsJHtwld6FCG4S2cb7+/hLvQg4ir+i/dVHOURKO1YpU0gnEKeQw1Ldbn49/WMo
         00otGN7UcAsKISwh5gABrijybH0x+OOo0hmeyLRYZGRUzYUbkLdkm2W8e5/LJexmfZNk
         aD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=m5JXOmTfBKNUXaoyaUbMC0qVBYGlHYto5nPX9Patf5M=;
        b=z1Kffuy/9r/Giu4PoU3Un3+vMNcAzHnzDpex/RH7ZugCaM7OAq//FRZivrxklFroUw
         I8WY6R8tTviIToA1vN9O+4vyU9Uv0aSJ4Yq45r3ghjayFQk6WYK7Surxn3cM3lzBjlnl
         7cGH3AQBCKVT7c/xyDoyUDcyqzwF5aE3pejtCIfsnq0blw2ELT4snbUvRFD0bUSjS6aV
         HYkh2J+p5esb07G3PieaqOe4rwHZOtEft0mNciFuIMfv6gJpoAiI6rWWxbla3csktwQz
         gyzEBIEenBeqf5sKmmfAAujV5vF0QINp1aQOx6/E9FyclgWN6J6pfd5z3MnbiqjQClAB
         vFJw==
X-Gm-Message-State: AJIora9FeuJNXgLAYFdWPqcYLx3suNiC3OXe5Es1pps77OMccAgipwS5
        +X40bY3b9OjuAGq3sbg4ODVi5w==
X-Google-Smtp-Source: AA6agR4MVlTUXHxYv42qQK7I867lJYSH5V8kCMUvlZJOb5W6zuqliBqtjyG++1chXju46MQoWV9twg==
X-Received: by 2002:a05:6a00:cd5:b0:52b:1744:af86 with SMTP id b21-20020a056a000cd500b0052b1744af86mr21392255pfv.19.1659457698396;
        Tue, 02 Aug 2022 09:28:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z16-20020a170902ccd000b0016c4e4538c9sm12033114ple.7.2022.08.02.09.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 09:28:18 -0700 (PDT)
Date:   Tue, 2 Aug 2022 16:28:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 24/25] KVM: VMX: Cache MSR_IA32_VMX_MISC in vmcs_config
Message-ID: <YulQniIhC25F+pT7@google.com>
References: <20220714091327.1085353-1-vkuznets@redhat.com>
 <20220714091327.1085353-25-vkuznets@redhat.com>
 <Ytnb2Zc0ANQM+twN@google.com>
 <87fsie1v8q.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsie1v8q.fsf@redhat.com>
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

On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Jul 14, 2022, Vitaly Kuznetsov wrote:
> >> @@ -2613,6 +2614,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >>  	if (((vmx_msr_high >> 18) & 15) != 6)
> >>  		return -EIO;
> >>  
> >> +	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
> >
> > Might make sense to sanitize fields that KVM doesn't use and that are not exposed
> > to L1.  Not sure it's worthwhile though as many of the bits fall into a grey area,
> > e.g. all the SMM stuff isn't technically used by KVM, but that's largely because
> > much of it just isn't relevant to virtualization.
> >
> > I'm totally ok leaving it as-is, though maybe name it "unsanitized_misc" or so
> > to make that obvious?
> 
> I couldn't convince myself to add 'unsanitized_' prefix as I don't think
> it significantly reduces possible confusion (the quiestion would be
> 'sanitized for what and in which way?') so a need for 'git grep' seems
> imminent anyway.

Yeah, no objection to leaving it alone.  VMX_MISC is such an oddball MSR that it
practically comes with disclaimers anyways :-)
