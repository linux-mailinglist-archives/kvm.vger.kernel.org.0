Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65DFB1232BE
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 17:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfLQQmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 11:42:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbfLQQmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 11:42:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576600968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CrCf/NwWYpCGoTQAsLWIUU7mZVErqP3JdIsj9e1SaPg=;
        b=SHRvw6AZ4IdvuqPcD6JfuTAuBoE7mWJuOyeo/5aF9o0gx1RHv4J3uWfLEKnSaqOjyqxhPF
        fmVAl6xbChYvOKBB3nYfybDqNjTkYztq5424LHpHIfjsnAXV1qHXL1v0zkmoRZK9DKh1VG
        y8sD51SGUg5K8BuG6Z4LT53FI4205I0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-BX-suriKPd68ZUBkqMrLPw-1; Tue, 17 Dec 2019 11:42:47 -0500
X-MC-Unique: BX-suriKPd68ZUBkqMrLPw-1
Received: by mail-qk1-f199.google.com with SMTP id a73so5802374qkg.5
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2019 08:42:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CrCf/NwWYpCGoTQAsLWIUU7mZVErqP3JdIsj9e1SaPg=;
        b=HKyrz3s4t7JWDCz/HdQe6OmV9PfZNV544I9iIOxdaGpUyIbovF131+3Czo6OHj/gD0
         etsfR7P8corC7JA8OT292y2/ax3u4BUpP632Teesy2+vwiTVvrRdQMPDF2INydFX25uT
         MwpJCYcvHJX/z4mzKtKyRoV6fAXj9WyFa57LD6B3/izTnd3Dus9OaVbCRdprwZ/jKsFv
         LW1IgYyKEXFmvQxwgbDlejna2y/80t3KCEKGqTwrNKh6nTJiv7mtBmOIAuZNC55+eA39
         3CITA+SkYZopffLeNS5PrSi4N9j18rGYU+r57hweeRmPqqzYrR4t+lYohWkfGKGk/7sa
         7z6A==
X-Gm-Message-State: APjAAAWVkpMn/BQQoW4D3rQFyfj3n7NXXHlIfNP8a3q3yl/6sdQBLOhC
        WFExau8QrWB+2k8AzpsYxa30BzICsJqWpZpbfH87tKG1EdWe4IL/HmxxV/U1YZa0+5wfoz5ZzIq
        TyTHrcczWWudH
X-Received: by 2002:ac8:21ec:: with SMTP id 41mr5448843qtz.242.1576600966836;
        Tue, 17 Dec 2019 08:42:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqwDiMxFU/n4dbLE4zkIZGOqGfipV+5VvUOqIWv7WdbeVIwoUMjJm6HdqztecpahePvpe+tBww==
X-Received: by 2002:ac8:21ec:: with SMTP id 41mr5448824qtz.242.1576600966557;
        Tue, 17 Dec 2019 08:42:46 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id t73sm7262985qke.71.2019.12.17.08.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 08:42:45 -0800 (PST)
Date:   Tue, 17 Dec 2019 11:42:44 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191217164244.GE7258@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <E167A793-B42A-422D-8D46-B992CB6EBE69@redhat.com>
 <d59ac0eb-e65a-a46f-886e-6df80a2b142f@redhat.com>
 <20191217153837.GC7258@xz-x1>
 <ecb949d1-4539-305f-0a84-1704834e37ba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ecb949d1-4539-305f-0a84-1704834e37ba@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 05:31:48PM +0100, Paolo Bonzini wrote:
> On 17/12/19 16:38, Peter Xu wrote:
> > There's still time to persuade me to going back to it. :)
> > 
> > (Though, yes I still like current solution... if we can get rid of the
> >  only kvmgt ugliness, we can even throw away the per-vm ring with its
> >  "extra" 4k page.  Then I suppose it'll be even harder to persuade me :)
> 
> Actually that's what convinced me in the first place, so let's
> absolutely get rid of both the per-VM ring and the union.  Kevin and
> Alex have answered and everybody seems to agree.

Yeah that'd be perfect.

However I just noticed something... Note that we still didn't read
into non-x86 archs, I think it's the same question as when I asked
whether we can unify the kvm[_vcpu]_write() interfaces and you'd like
me to read the non-x86 archs - I think it's time I read them, because
it's still possible that non-x86 archs will still need the per-vm
ring... then that could be another problem if we want to at last
spread the dirty ring idea outside of x86.

-- 
Peter Xu

