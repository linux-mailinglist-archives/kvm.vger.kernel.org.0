Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F9043F2B0
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 00:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhJ1WZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 18:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhJ1WZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 18:25:09 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD66C061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 15:22:42 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q187so7907906pgq.2
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 15:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xig/8+VytIEPDHmArfWc5mfSOVk17KuJyrqSgvYJyOs=;
        b=hgU2soGW7AfQ7NaUyZ4nffXm0qun3esMriPB2H9FJ7Nx7eRC2L1Y0/GOcxhjBGLrY+
         589r+1dfNmhESH4dGtWZlq2IZTbE1aCMsXVNMb3n4iQWM2CKMXHSIOFHnSZqdF1RSmqU
         QV1PPNkU/oI3os6J39eA8YW4GkJLemzRTmvMwvJOl7yAe1cBBW/s07z91D/9yiLQY5xh
         TRHmOD86XO+P6Ln6ZOA23r3KPuIHqDXJYjqUvgboaghWYN3eFxK4SXZEfAAzJJYvlt1i
         cGqQmQ0TVrMTWOZ89AKeEDqNKh3gEiLvHkdgVI8LYiAjQZ5CmyruMeZmbT52wVGqWs9J
         kRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xig/8+VytIEPDHmArfWc5mfSOVk17KuJyrqSgvYJyOs=;
        b=owklUaqGoNfLz9U6k6qy16FQF+qhkVAlcXvrT4ftlZxLIi7EXDxoDRAKhdU1Zuu0Ss
         sLJIaA0x/hsi4homPLVweJOzlcqJ1flX5OJe2RVrVkc8u1Nezmc2e/cFOZCuzLeoMTMb
         GtgDnt2ESUtFixQvZnqzbZsoUSYUD4bOUYWR55PRf57K7+aWkK06VdSSqA8aENZWKlX6
         Dtinu0Om8F/xEYJpyvjDQQ5jrYQv5GvF7dpQN87qcsmAWW7e/DH7lmguvbm1SPSbc6aL
         VHI7OH1wbbMJ4MvZ33LFYfXTD+CBqvQCIEajg0fOu+GWractKC6Z2Ez53SHULTFkQfgN
         8a8Q==
X-Gm-Message-State: AOAM532uGxUXj+y1e+C2Vu4tkeuklCkkSxsYmkDusuPxS4RXJAHca3dV
        uOA9aRaTD3vZIGjQ7GEFRMGi8A==
X-Google-Smtp-Source: ABdhPJxEtn33Gw2zRPXkxiZT5SnDKN0clHb+NicQp5AJhAZFDpYvux6fOlAQrrwBiu14fZe76iEhCA==
X-Received: by 2002:a05:6a00:1393:b0:47b:ebaa:7dd3 with SMTP id t19-20020a056a00139300b0047bebaa7dd3mr6847509pfg.17.1635459761858;
        Thu, 28 Oct 2021 15:22:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 125sm4343927pfv.155.2021.10.28.15.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 15:22:41 -0700 (PDT)
Date:   Thu, 28 Oct 2021 22:22:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 11/13] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <YXsirUMNdgmWXKxC@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <0c35c60b524dd264cc6abb6a48bc253958f99673.1632171479.git.maciej.szmigiero@oracle.com>
 <YXie8z7w4AiFx4bP@google.com>
 <YXnmrqhvc4mzxZfn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXnmrqhvc4mzxZfn@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 27, 2021, Sean Christopherson wrote:
> And doling out the work to helpers also mostly eliminates the need to track the
> inactive vs. active slot.  There's still some slightly twisty logic, especially for
> the MOVE case (which nobody uses, *sigh*).  If we really want, even that mess can
> be cleaned up by pre-allocating an extra memslot, but I don't think it's worth the
> effort so long as things are well documented.

Aha!  I figured out how to do this in a way that reduces complexity and fixes the
wart of "new" being an on-stack object, which has always bugged me but wasn't
really fixable given the old/current memslots approach of duplicating the entire
array.  I belive it "needs" to be done as cleanup on top, i.e. what I've proposed
here would still exist as an intermediate step, but the final result would be clean.

Rather than reuse a single working slot, dynamically allocate "new" except in the
DELETE case.  That way a "working" slot isn't needed for CREATE or FLAGS_ONLY since
they simply replace "old" (NULL for CREATE) with "new".

It requires an extra allocation for MOVE, but (a) it's only a single memslot and
(b) AFAIK no real VMM actually uses MOVE, and the benefit is that it significantly
reduces the weirdness for the code as a whole.  And even MOVE is cleaned up because
it more clearly replace old and invalid_slot with new, as opposed to doing a weird
dance where it uses the old slot as the "working" slot.

Assuming my approach actually works, I really like the end result.  I got waylaid
yet again on other stuff, so I may not get a series posted today.  *sigh*
