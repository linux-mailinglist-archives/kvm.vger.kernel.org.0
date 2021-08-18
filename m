Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381073F0ECD
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 01:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhHRXuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 19:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbhHRXuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 19:50:06 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B18C0613D9
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:49:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y190so3791628pfg.7
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 16:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xWVGgzNhg0bKowDgMtAJdc0jrte6ReRvwJNGpqgXHy0=;
        b=kMt57PvYngH7Nf3lS9QzTNHmKMN8MCBHcYbGc/18ZJHNioFors2TS2bW66NQljnmeH
         hK0oD00wN+LBenyrm02ZNL1bVlJIOCEUY6xuY/iLm2b5XUvyNJFV/31mwM/BgbcnXXnE
         9PwpurECHnsefQZDhHp6+8FkngJoW6norYKIzgwi7rWhMh1ByU+q6e94WQupwcjG3DQQ
         rLpPVyj/oHStckruB5Gce3dYVffe4FzOnBGfPv2+3ZLRmy7eutFMAsbo2II54+MImTlV
         IvF7LaR4ZJxbAK4dCbrgyKzbM74kuuRvLn622jGRzGZWYgRPc0EvrMgTvJLoR3K60L6Q
         UNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xWVGgzNhg0bKowDgMtAJdc0jrte6ReRvwJNGpqgXHy0=;
        b=Lx/PioVoWPbASYfHFLwpbuxa52/BbjrNUJZJtTJDgkoXKOlsuJ8hlFhmnJdm2bn+yp
         AEKr6EZaJ/I1Oyrqhbsz6mC0Ralmt1+hAe9wkUZw5LmXPG+dTLaYA0IWdIY1mhKrEb6d
         itfS5GcVyTlJDT7+wJyZQaKe1W11EG5l9ibDY5f2YGGkC/ZoSvc4xkCTTMtQf1QwMfbe
         tteDRIhO3fZMLSOh0ouOzQuCds7DkaelV8iGaSa0EgAQdln2ILfVoZdxPMrpiESbusPH
         X6p4dPHqbwGd6XlAGyLDj8q2AE8Gk7uuPs36Mr7U/ytTXHvvuqsFayC4zlCofT+fsddu
         Oygw==
X-Gm-Message-State: AOAM533MrHSOPVaZpoxC16bVLWQyv70tKRzWOB+OblisT1cBaDiMQFvN
        sRo2oCF+f4rZPidiA4RQsToWTA==
X-Google-Smtp-Source: ABdhPJzG9Vf9ORYGtC4jJSfs7Mu1PycovbhksanngZOwZI+w+ZRYjv3xIxU/XsOEKcW6GEHsWVXKsA==
X-Received: by 2002:a63:204a:: with SMTP id r10mr11186295pgm.365.1629330570276;
        Wed, 18 Aug 2021 16:49:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ga22sm5519792pjb.29.2021.08.18.16.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 16:49:29 -0700 (PDT)
Date:   Wed, 18 Aug 2021 23:49:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YR2chNdSyyAtjCU3@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
 <YRvbvqhz6sknDEWe@google.com>
 <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com>
 <CALMp9eQnq9RDQiRmfOge52Yx8SCM5D2nAM-0bcqaGJQJXvgfDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQnq9RDQiRmfOge52Yx8SCM5D2nAM-0bcqaGJQJXvgfDA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021, Jim Mattson wrote:
> On Wed, Aug 18, 2021 at 4:11 PM Sean Christopherson <seanjc@google.com> wrote:
> > This is quite the complicated mess for something I'm guessing no one actually
> > cares about.  At what point do we chalk this up as a virtualization hole and
> > sweep it under the rug?
> 
> Good point! Note that hardware doesn't even get this right. See
> erratum CF77 in
> https://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-e7-v2-spec-update.pdf.
> I'd cut and paste the text here, but Intel won't allow that.

Ha!  KVM's behavior is a feature, not a bug, we're just matching hardware! ;-)
