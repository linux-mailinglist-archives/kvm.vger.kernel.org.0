Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52E41209F9
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 16:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfLPPn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 10:43:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40779 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728350AbfLPPn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 10:43:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576511038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FUEPuE3lmiTROt831qEr7XPbzQitQcYsLEoUTolKxh8=;
        b=BOeA2K7SS9uuSj0SMofQmkmi76EjRnjaex0Jd15461oGBP6gdmcbKDuh0HzkvXhVHfTUlD
        d3+RA7+hwKvu3a7lWXygJSAC3Ghu3DgOhVDImg+DmR/cVOko6Tk0cMQ3N3U2QrJspIQT+4
        qRbI38a7m4ink10ANQgg7R8SAXMKvfw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-4wXtKD65NtacG4Ho_Xjv0w-1; Mon, 16 Dec 2019 10:43:56 -0500
X-MC-Unique: 4wXtKD65NtacG4Ho_Xjv0w-1
Received: by mail-qv1-f70.google.com with SMTP id c22so5527178qvc.1
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2019 07:43:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FUEPuE3lmiTROt831qEr7XPbzQitQcYsLEoUTolKxh8=;
        b=FxzdnksiKDH1KnwscsnNvdBKbI7IJYTLKxc6F4gM8Xr6Sj9kzCh3FGa7R7eaG2utx7
         cgu+hhR8rVE5v6DRRDFCrNhgRk9rp6CSZYvtUxfhRuRCYqBKSC/agW3H/k07tdZ8CH+7
         nmA5tQJk3ARKyGiGWX8RIIMH1sKvdfyjAV+E1pA9GhEXissck8wVGt3C2ENSCMsYj6d4
         YFApxJNHUgX2leaUGqKKquERF7rzX4ghxobHi05r++nXXpnlHvLY7Iuf7f2bN4jy/wxF
         cMx99IIYjrLpDy/CbsAPgGjW/0AOmzDOaUsXvmiPWhwAux5hdiUK8b4SToe65RJclFni
         rDkw==
X-Gm-Message-State: APjAAAVmtWZaCKngpfTEuGsNs/cvEibKmlProztIRwpILZvrnApsd8Bc
        JbEUtv0VK+fM67SdC+RlOaRWg0mwQv3Ho7oY8/Ho6Rx7ouieEjvkvXwjgz3H8laO2O1wGRRrzGi
        /26eEWDt5bqfs
X-Received: by 2002:aed:376a:: with SMTP id i97mr24765824qtb.44.1576511036533;
        Mon, 16 Dec 2019 07:43:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNO+M+uMPH2PC7v8tiGPqdgQ481MGIvuyPN8mLjwyvKqfzFBQlyb23FzKFU9qaIy6pSbyfug==
X-Received: by 2002:aed:376a:: with SMTP id i97mr24765811qtb.44.1576511036310;
        Mon, 16 Dec 2019 07:43:56 -0800 (PST)
Received: from xz-x1 ([104.156.64.75])
        by smtp.gmail.com with ESMTPSA id f42sm7002645qta.0.2019.12.16.07.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 07:43:55 -0800 (PST)
Date:   Mon, 16 Dec 2019 10:43:56 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191216154356.GE83861@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
 <20191213202324.GI16429@xz-x1>
 <bc15650b-df59-f508-1090-21dafc6e8ad1@redhat.com>
 <20191214162644.GK16429@xz-x1>
 <0f084179-2a5d-e8d9-5870-3cc428105596@redhat.com>
 <20191216152647.GD83861@xz-x1>
 <fa25d729-a2fb-85af-a968-1dedc754a55d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fa25d729-a2fb-85af-a968-1dedc754a55d@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 16, 2019 at 04:31:50PM +0100, Paolo Bonzini wrote:
> No u64, please.  u32 I can agree with, 16-bit *should* be enough but it
> is a bit tight, so let's make it 32-bit if we drop the union idea.

Sure.

-- 
Peter Xu

