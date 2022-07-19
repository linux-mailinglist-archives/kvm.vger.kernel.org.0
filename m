Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF91C57A6CB
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 20:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiGSSzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 14:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiGSSzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 14:55:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09278F7B
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 11:55:06 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id r186so14312670pgr.2
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 11:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ivVC9EM9jM66mJwYdCa12X2ciIU5HLlT0VikbwcqW18=;
        b=MnT5x6BW+UKIQ9tTlvQG7AAUoEnxPFr6NnmrcUd/RurtAKZFDIiMg5JUfsF3geEtkf
         ZrZGcTGi12Q0VNsAJrY+9AnTQZiZJwJ3FvhtI+E7NDJBKG95qboQwkRYn/fYPh05sQb0
         he9T+4zweUVHob4/7oBcwbOqOdd5JOyMuFsRnle91Go/rjAErLuaVhk45YK1Hlpt/x6u
         atHackoDC6xIcsPJReC4pjUWkdBX+hE5s/0GiV8ZzL1OlgNu3sEvrmtpaZH3b+DPRJgZ
         XxBE9rBrogIyvNj/R5TQAAUHa6Yik8hM/f1v0kU2DrBw+rqgyJazV0cgCARTGeIGw9Ol
         bxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ivVC9EM9jM66mJwYdCa12X2ciIU5HLlT0VikbwcqW18=;
        b=vKeccXWs4WFsPAs+nvSkwEIWCBqpjzICP6J/sBgVJFDYpvwWB5jLlXDzaKP2KLscZo
         MKwjXC1oxE/bnbmHuVpPSHkvmA8BBholcizPpfZJs5KnNpv8fv9MQBVVKOy6R3xD6Vc4
         I+2rDf7AR8Dg816lewFcw6JygmRNSS2OFVRFGHaMhs3tvZA9dFbgbfVaH1RSLJgw0LAq
         Cqw5prxYPaDRN4/YToUP1sHHZoo4G6ZVgNIRo/n6rQsgXB/18jqx+rprfJdIsZ9BpUr4
         GZ0Ur/7S3W5JkzR85ien2liE6a+blgJn4aGLRDRe/DhU+sK5mntZaE50Pv+xksRv25q8
         0idw==
X-Gm-Message-State: AJIora/XvC/XFuwfLRyuALsNRGSAExy7NktlDr3EN2YPcZqUaRd4beAO
        /wTSeP8ktbJe5e0/H6NEV6m+5g==
X-Google-Smtp-Source: AGRyM1uBI1w+9Wit78V4mJ9Xfvp+eS4Z/zhmPnP8YfL9Lneiu0bXaLfHGedZMlFDpPHBVaepTaV92Q==
X-Received: by 2002:a05:6a00:1daa:b0:52a:c51d:d36a with SMTP id z42-20020a056a001daa00b0052ac51dd36amr34595993pfw.61.1658256904800;
        Tue, 19 Jul 2022 11:55:04 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bebb0cb96sm12179765plx.266.2022.07.19.11.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 11:55:04 -0700 (PDT)
Date:   Tue, 19 Jul 2022 18:55:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        jmattson@google.com
Subject: Re: [RFC PATCH] KVM: x86: Protect the unused bits in MSR exiting
 flags
Message-ID: <Ytb+BZReuuD+2rpd@google.com>
References: <20220714161314.1715227-1-aaronlewis@google.com>
 <8da08a8a-e639-301d-ca98-d85b74c1ad20@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8da08a8a-e639-301d-ca98-d85b74c1ad20@redhat.com>
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

On Tue, Jul 19, 2022, Paolo Bonzini wrote:
> On 7/14/22 18:13, Aaron Lewis wrote:
> > ---
> > 
> > Posting as an RFC to get feedback whether it's too late to protect the
> > unused flag bits.  My hope is this feature is still new enough, and not
> > widely used enough, and this change is reasonable enough to be able to be
> > corrected.  These bits should have been protected from the start, but
> > unfortunately they were not.
> > 
> > Another option would be to correct this by adding a quirk, but fixing
> > it that has its down sides.   It complicates the code more than it
> > would otherwise be, and complicates the usage for anyone using any new
> > features introduce in the future because they would also have to enable
> > a quirk.  For long term simplicity my hope is to be able to just patch
> > the original change.
> 
> Yes, let's do it this way.

Heh, which way is "this way"?

  (a) Fix KVM_CAP_X86_USER_SPACE_MSR and cross our fingers
  (b) Add a quirk
  (c) ???
