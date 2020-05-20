Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4A21DC15A
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 23:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgETV2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 17:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgETV2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 17:28:13 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565ECC061A0E;
        Wed, 20 May 2020 14:28:12 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbWFz-00Cc4Y-5f; Wed, 20 May 2020 21:28:07 +0000
Date:   Wed, 20 May 2020 22:28:07 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 22/24] uaccess: add memzero_user
Message-ID: <20200520212807.GD23230@ZenIV.linux.org.uk>
References: <20200520172145.23284-1-pbonzini@redhat.com>
 <20200520172145.23284-23-pbonzini@redhat.com>
 <20200520204036.GA1335@infradead.org>
 <e2e23a99-f682-1556-dad0-408e78233eb6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e23a99-f682-1556-dad0-408e78233eb6@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 11:13:36PM +0200, Paolo Bonzini wrote:
> On 20/05/20 22:40, Christoph Hellwig wrote:
> > On Wed, May 20, 2020 at 01:21:43PM -0400, Paolo Bonzini wrote:
> >> +			unsafe_put_user(val, (unsigned long __user *) from, err_fault);
> > This adds a way too long line.  In many ways it would be much nicer if
> > you used an unsigned long __user * variable internally, a that would
> > remove all these crazy casts and actually make the code readable.
> > 
> 
> Good idea, thanks.

Unless I'm seriously misreading that patch, it could've been done as

static inline __must_check int memzero_user(void __user *addr, size_t size)
{
	return clear_user(addr, n) ? -EFAULT : 0;
}

What am I missing?
