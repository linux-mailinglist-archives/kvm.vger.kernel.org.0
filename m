Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F050518B17
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 19:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbiECRel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 13:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240337AbiECRek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 13:34:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2BE71CB3E
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 10:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651599067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TScWbWXEVWKnRBFQAFHlKCvx6D9GWzgwwEuiYtBAwlw=;
        b=gl1myuvoIxAXL+k8XlvmEr1FUz/1fCHVd6NLLalGAQix3DCC8F8tFdOCWaSwtUYVYUGcdD
        XYme7E28kKUgq6Mgvbj7I9qsIlluxo99ss8dktx7FbqYPOPqgw2qqOcFv+DthGkPPQ7NhW
        2VLpYuAhuSpC4gdGQYcmoZrLys5ga7U=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-fCVdMqNkNx6Q-x0LIJTvEw-1; Tue, 03 May 2022 13:30:51 -0400
X-MC-Unique: fCVdMqNkNx6Q-x0LIJTvEw-1
Received: by mail-qk1-f200.google.com with SMTP id bs18-20020a05620a471200b0069f8c1c8b27so12820815qkb.8
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 10:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TScWbWXEVWKnRBFQAFHlKCvx6D9GWzgwwEuiYtBAwlw=;
        b=Fgj0HPfOOc6kpvQ10QN8CNwdHw4U0ysgb1MgUQ1lBlWzvlrjoIq9G3y79M5keNwlBN
         54Z17/q8W4pg672UQmd46lGJsQTmMlVqGlcZ3eFPMhelhHI+004+em46Lep2vTGrOOnx
         kMDL5bDkhcEdp2r7P1CL734dODJ76VodZeMKC6hPYQlp9VRMHc2vu0GRXsbM7jRHhvTU
         VQraQuUikaFQs/niW3xTDhaCVRuL7zJ77OQnB3ha59fYInzzU7yLQ903mQ5OzfSoO5YH
         481MpQ0v76PolZkKTc0OuaGQ1SEifsg9/rHfYNJMR9G+AJt1jMBs+fT8BGlsLitpHPVb
         eNiw==
X-Gm-Message-State: AOAM5308eH/Lx6iqPa6n5Ia1PZfgiMQaitdztlUzZ3UEkf0DYaAM+Lu6
        bf4CxqS8iFgeUYeqyhFaNbacW/ec1H0Ve4RgiH82WsYIuFOKE3mYnAfc1VklqEkcdQMqm1DicZy
        mZBqpdJcZKq4W
X-Received: by 2002:a05:622a:309:b0:2f3:7d75:8409 with SMTP id q9-20020a05622a030900b002f37d758409mr15587836qtw.485.1651599050645;
        Tue, 03 May 2022 10:30:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjXJ6WRKqUWq4aJyRjPRGX9HKH3Wk5dPulo0BzJo+htkxjC4tIchweNZkYHPts6wI7BFCeNQ==
X-Received: by 2002:a05:622a:309:b0:2f3:7d75:8409 with SMTP id q9-20020a05622a030900b002f37d758409mr15587816qtw.485.1651599050430;
        Tue, 03 May 2022 10:30:50 -0700 (PDT)
Received: from treble ([2600:1700:6e32:6c00::a])
        by smtp.gmail.com with ESMTPSA id y144-20020a376496000000b0069fc13ce1efsm6104766qkb.32.2022.05.03.10.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 10:30:49 -0700 (PDT)
Date:   Tue, 3 May 2022 10:30:46 -0700
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Seth Forshee <sforshee@digitalocean.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
Message-ID: <20220503173046.fv2aluc34bxhzgq3@treble>
References: <20220503125729.2556498-1-sforshee@digitalocean.com>
 <YnE5kTeGmzKkDTWx@google.com>
 <YnFVugyU8+XBVRqL@do-x1extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YnFVugyU8+XBVRqL@do-x1extreme>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 11:18:02AM -0500, Seth Forshee wrote:
> > Can the changelog and comment use terminology other than migration?  Maybe "transition"?
> > That seems to be prevelant through the livepatch code and docs.  There are already
> > too many meanings for "migration" in KVM, e.g. live migration, page migration, task/vCPU
> > migration, etc...
> 
> "Transition" is used a lot, but afaict it refers to the overall state of
> the livepatch. "Migrate" is used a lot less, but it always seems to
> refer to patching a single task, which is why I used that term. But I
> can see the opportunity for confusion, so I'll reword it.

The livepatch code does seem to be guilty of using both terms
interchangeably.  I agree "transition" is preferable.

-- 
Josh

