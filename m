Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7773831D383
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 02:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhBQBEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 20:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhBQBEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 20:04:09 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93300C061574
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 17:03:27 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id m2so7431518pgq.5
        for <kvm@vger.kernel.org>; Tue, 16 Feb 2021 17:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qtwKaBiuPYUvz0xWl8m1S45ms1wew6GiKaYyXPstShY=;
        b=hR+6zsrZvmQI1jiLm98fGBSwoksg+qAfy20KAE1ORvWET6C9nkuhCS8n4UTgOAZKkv
         QObyw5pSdj33watWVnWiNP07EWbdZc74aX3ehGOZmjNbuJztbzqGFDJ06jB74mjrQ/pw
         GwWTJssT9ffcLgU021QHckdCmh/VNAyERhwRqiHu/8cN8bn6eYhGi6ba7zj1drC7Ohsl
         N/NZROd+s7fujzMa4Y/UxFsjQvwP02LO3CFyvFdXyiEVmhYr3K4QwyIWmcUIkeC7PwfT
         /wSZgn/cMzk70byBU5oQZGLzMpyCslk3pmdvj4l6poYtvj9ILOCqPptxG9q9b97JaxDH
         F97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qtwKaBiuPYUvz0xWl8m1S45ms1wew6GiKaYyXPstShY=;
        b=iUNuWLSPnPyZsAfdvc8mv0r6ZXcDr7ugP/C3WnT4N8yJbochqRj8uHUwNilEM+LKP8
         ZqQVEgSe73pMS/CeylcfLtUN9r7dHKPoihID8BL9guvBeuihE/qVs5k6pLNRlMlXVNwn
         sSrroAkR7oGhASosWUpEauSjTmUVHyaH7wFb+wDPrqnqzsGl4OYCS99jhKcPqg2uJQBA
         BjEdYpKayJiYwoNl/G78tH7wfJl8KAEJfSvz77mF7spP8ZBoNjGtLYPJjr0EHLHcZ16X
         GL2aUdr1XExy29RRyYi18AkxG6ATesM0rY3WKyEBXt2DnEQF8pKN23HT6GlU+D6x8Qsf
         XjnA==
X-Gm-Message-State: AOAM530oxjJQWGbc+RL7MWL0fSBvxkmk2W6mxRKV1DHTA8x+78+0Ynxe
        ufbdi944oHLbP2YA7ezYb1uGKA==
X-Google-Smtp-Source: ABdhPJwjZFj3CFYYa4dEPkFYRXMEe77KR30ZgCJLDDPCSZBQF+i+bCpafGAOHWyio9En1S2D5oOqgg==
X-Received: by 2002:a63:4e4c:: with SMTP id o12mr21708720pgl.143.1613523806692;
        Tue, 16 Feb 2021 17:03:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id v31sm308840pgl.76.2021.02.16.17.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:03:25 -0800 (PST)
Date:   Tue, 16 Feb 2021 17:03:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <YCxrV4u98ZQtInOE@google.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The ioctl is used to retrieve a guest's shared pages list.

What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS is passed
through to userspace?  That way, userspace could manage the set of pages in
whatever data structure they want, and these get/set ioctls go away.

Also, aren't there plans for an in-guest migration helper?  If so, do we have
any idea what that interface will look like?  E.g. if we're going to end up with
a full fledged driver in the guest, why not bite the bullet now and bypass KVM
entirely?
