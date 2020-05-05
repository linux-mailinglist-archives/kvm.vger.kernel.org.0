Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637B01C584E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 16:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgEEOMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 10:12:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729219AbgEEOMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 10:12:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588687973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9QocmiR79ciyCV8YIogR/mIbS+d3+LtRW/0KmEr7MtM=;
        b=AK91HaCdxzzh+Ok3RhNf8TmX9FPmxLlgJvGM/sAUXt8yU8Q+FOT+LlatDomXtpLJ2eVbIH
        Zi/2AjYwumepS7cJm1SArMcMMOIrgxA0a/T7hOLSPhLMJ0JjeH0LkTrmtod527fM6JSjSW
        tBz1VQ7d1+yAa7UsdNe2KEqAulCIwFE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-mYvEafkdMVayLO53mrf9Dw-1; Tue, 05 May 2020 10:12:48 -0400
X-MC-Unique: mYvEafkdMVayLO53mrf9Dw-1
Received: by mail-qk1-f198.google.com with SMTP id z8so2314326qki.13
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 07:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9QocmiR79ciyCV8YIogR/mIbS+d3+LtRW/0KmEr7MtM=;
        b=lRfwtva4F88BFwemjWWN+9S/h+RDPeqY7ErLY1/ZZVOxW0fUkQMNU/0I0ij4ybvqE3
         phZe1mKj1EuXuA2CRtAXR0FouipAcOy+b38S6wpaOaDdIyCHDg9JoMKenZsf9TKJa1Zj
         0BPi3kkKnG32SYJPKjSmmEVXXN4/q0fOe+aa7sjKBgHFIpPVp9VrNckWyvVFTy35iKEP
         afctcgg+hmb68rA5cgz9pgdZAiCXR049d4jdwQRb97j8Miz4h/ioZBFRwKXGcrjXcavV
         uZZbH5jJuQPq0S9WkqwsiJZYX3Qo/jf5+UP9cjosJRBeSW9QzE9SViRkOwu184izKtxs
         1KYA==
X-Gm-Message-State: AGi0PuahNTu4owKwv8Lr6PooS1aCoDscTEAggGFpiAvloDDfrjq9VSmB
        15noEIepDvNWNJZmQSevTmo+smHWJ4jiUUU40RFDERV1pJjX/sFtQhLS7CdLMOmhXBx+SkRmIeJ
        +eDzbZt7A7U9a
X-Received: by 2002:a05:620a:112c:: with SMTP id p12mr844434qkk.313.1588687967629;
        Tue, 05 May 2020 07:12:47 -0700 (PDT)
X-Google-Smtp-Source: APiQypL2JXMwNHFY++ym7AgRDXitYWpCdW9rKuEVfwZfFB1urpeidfFT0kVgaOLz2D8FZ6rVTNljng==
X-Received: by 2002:a05:620a:112c:: with SMTP id p12mr844411qkk.313.1588687967341;
        Tue, 05 May 2020 07:12:47 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v5sm1810925qkg.9.2020.05.05.07.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:12:46 -0700 (PDT)
Date:   Tue, 5 May 2020 10:12:45 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Fix a warning in __kvm_gfn_to_hva_cache_init()
Message-ID: <20200505141245.GH6299@xz-x1>
References: <20200504190526.84456-1-peterx@redhat.com>
 <20200505013929.GA17225@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200505013929.GA17225@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 06:39:29PM -0700, Sean Christopherson wrote:
> On Mon, May 04, 2020 at 03:05:26PM -0400, Peter Xu wrote:
> > GCC 10.0.1 gives me this warning when building KVM:
> > 
> >   warning: ‘nr_pages_avail’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >   2442 |  for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
> > 
> > It should not happen, but silent it.
> 
> Heh, third times a charm?  This has been reported and proposed twice
> before[1][2].  Are you using any custom compiler flags?  E.g. -O3 is known
> to cause false positives with -Wmaybe-uninitialized.

No, what I did was only upgrading to Fedora 32 (which will auto-upgrade GCC),
so it should be using the default params of whatever provided.

> 
> If we do end up killing this warning, I'd still prefer to use
> uninitialized_var() over zero-initializing the variable.
> 
> [1] https://lkml.kernel.org/r/20200218184756.242904-1-oupton@google.com
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=207173

OK, I didn't know this is a known problem and discussions going on.  But I
guess it would be good to address this sooner because it could become a common
warning very soon after people upgrades gcc.

Thanks,

-- 
Peter Xu

