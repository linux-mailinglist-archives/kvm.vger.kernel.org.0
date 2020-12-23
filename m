Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5EBB2E1FAA
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 18:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgLWRAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 12:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgLWRAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 12:00:39 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F71BC061794
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 08:59:58 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b5so93969pjl.0
        for <kvm@vger.kernel.org>; Wed, 23 Dec 2020 08:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G8haU6BgXULIrV8nV+mOGhVrtDsLgWYDMHodNPq2c+k=;
        b=nxPF6DLi6PTF0R1avGovdGl1yW4NZ8C/usi9HXWThHlIk3eOQOakcdVAxyVpWPeTb4
         hRUF9h797fyDzMLZrR5R67Rn8/aPmRk8aNiI6SJP0fqqgn1PymMpQy2ILAHN2gMyjef4
         Cgun7GK5wQGeJzB4iOZGUjuqJj2hWsNonS4uyEGEbcamplVyUZ9aXFwl3HGW2ypZwT9+
         21Xn2uDfssm05OHOinVd9t+3nRpXfXre6mcx7gX1TUChiVl7YdsYcxlZZ05JbyfJLB4P
         swIXgLROgVYIZFem4Z+BPeH/bni5xVKztZ9/KwgU5fuLQrojhgnyGvlDZ3s6sw4o6aZM
         Hr0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G8haU6BgXULIrV8nV+mOGhVrtDsLgWYDMHodNPq2c+k=;
        b=R0g1smhKKuN/MwcEtk7qmMBgm2qBGEYcYXlEilcf+g8SbpNhjHVWOi9y5SL949ia8V
         JEqTaN1X1gHJPOXRkLLWEUWGhQzeFg2tNZKLGbWwQzFCKhZjlRLwg1lstF3262fyZ5wV
         muvo808GDH7Ttbb2ksJdpf5gc5GrnFvMcqkl51OglTYmwbRoYVPrMFDEvRzx0zgb6RYf
         aUdnFdOZHyn8PiyAfnNsU1XOw5dxxeD7vGRTqAYxOZ2JgYctV+u06BlPahDp4EmMkW8a
         N4iSt9IvrS/230h15K3zr/nnwOFzJQVDMWSBH6UretvgkIzaObMxFRmYsC15ljxgbsxX
         Q2Uw==
X-Gm-Message-State: AOAM530XC5Xg43X9sKQug7sPKgHH4AbXpSqOizNtXN0YPspoci/8Cm57
        bO+m5eTfzkowj8OWBU8/mD93Gw==
X-Google-Smtp-Source: ABdhPJwrxbMbXNCeVLzSh02VxbXirb6C3y1Atdo4OBb9bMh8QwovcHwhyJG3rO4RvsGQ8ZU5NM09Sw==
X-Received: by 2002:a17:902:34f:b029:dc:3032:e47d with SMTP id 73-20020a170902034fb02900dc3032e47dmr23626341pld.15.1608742798161;
        Wed, 23 Dec 2020 08:59:58 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id h20sm24177929pgv.23.2020.12.23.08.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 08:59:57 -0800 (PST)
Date:   Wed, 23 Dec 2020 08:59:51 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com" 
        <syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com>
Subject: Re: [PATCH] KVM: x86: fix shift out of bounds reported by UBSAN
Message-ID: <X+N3h9b5ieAxl6n/@google.com>
References: <20201222102132.1920018-1-pbonzini@redhat.com>
 <X+I3SFzLGhEZIzEa@google.com>
 <01b7c21e3a864c0cb89fd036ebe03ccf@AcuMS.aculab.com>
 <64932096-22a8-27dd-a8d6-1e40f3119db4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64932096-22a8-27dd-a8d6-1e40f3119db4@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 22, 2020, Paolo Bonzini wrote:
> On 22/12/20 19:31, David Laight wrote:
> > > 	/*
> > > 	 * Use 2ULL to incorporate the necessary +1 in the shift; adding +1 in
> > > 	 * the shift count will overflow SHL's max shift of 63 if s=0 and e=63.
> > > 	 */
> > A comment of the desired output value would be more use.
> > I think it is:
> > 	return 'e-s' ones followed by 's' zeros without shifting by 64.
> > 
> 
> What about a mix of the two:
> 
> 	/*
> 	 * Return 'e-s' ones followed by 's' zeros.  Note that the
> 	 * apparently obvious 1ULL << (e - s + 1) can shift by 64 if
> 	 * s=0 and e=63, which is undefined behavior.
> 	 */

Works for me, thanks!
