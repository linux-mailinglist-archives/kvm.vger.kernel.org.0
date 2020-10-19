Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F2D292CEB
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgJSRfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:35:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgJSRfy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 13:35:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603128953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/RufWKnLZUskTlxf1MZpvMgrqUwpnS/7Ou19TQ6qNrc=;
        b=Cm+rYkH0hcRUzMrzyl+1sKfhFmvhOAZM1KF6DXXXeFsnhqlgj1rnGHkVLFfhwczWbw/FsF
        pNOBSKbaqSAxD2T3e+zckQMT7Iss+79H4mbgYtReGyEVP+nwxJwSd0X+c7xbuCbOF6L3hd
        LZgSM6UzRT8QbudsvtncognpO/Ydu+s=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-_mNJYO3CN6uK5Pr1JyJq9A-1; Mon, 19 Oct 2020 13:35:50 -0400
X-MC-Unique: _mNJYO3CN6uK5Pr1JyJq9A-1
Received: by mail-io1-f69.google.com with SMTP id v7so634167ioe.7
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 10:35:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/RufWKnLZUskTlxf1MZpvMgrqUwpnS/7Ou19TQ6qNrc=;
        b=UAz43qdRjSGThEL5KIBpSRbP3ffnPKvCjBlkpDZuMx+hxS+6d3QoO/ZDhrdJV6snK5
         wY2OmKqCAckqiS9CkMtcbRTziWhMa4kWHpoTOSq3NJXZy4GIQPODTh0duFbteZ8HWDSi
         DQk0iVI6vIioTsslqC1QH28u7s1yhuSU1HrXvzIGJUNv0mRBfP2LnGiGTXREzaTpoNw9
         MQLnbCcKPkc+bcXgAcLzH9LZzNsZEogmLM1ncXR6dPin0nF4KvqIFglCeuz3F3HQAD7X
         E1BEFdPcQAgtoPoB6ezoxuCNJs6FPQ+LBu8CVx467Gu0z3S98ZGndnreDegXYo1aeTCW
         110Q==
X-Gm-Message-State: AOAM532FwIMBmGFMHfzPVvjM9+ucVNp6aiiseQtc7PzM3OCtvHq1ymll
        /r3CB9a9GPV4l3yyK/S3HO10tXLN6ZSR5T/03TfqatJF5IqTwmOV4OZDrzeS0mRYgy8fV3RxSYr
        LlqSx5O109axh
X-Received: by 2002:a6b:cd83:: with SMTP id d125mr449082iog.174.1603128950130;
        Mon, 19 Oct 2020 10:35:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+bURNpXTe1n9PgAEbCYBrgDNhf0ddoGYqPH6Xk8CtU5WYkmvye0WwXAuZZUa7bdlmNtav0g==
X-Received: by 2002:a6b:cd83:: with SMTP id d125mr449059iog.174.1603128949880;
        Mon, 19 Oct 2020 10:35:49 -0700 (PDT)
Received: from xz-x1 (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id g185sm367924ilh.35.2020.10.19.10.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 10:35:49 -0700 (PDT)
Date:   Mon, 19 Oct 2020 13:35:47 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Alexander Graf <graf@amazon.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] KVM: VMX: Forbid userspace MSR filters for x2APIC
Message-ID: <20201019173547.GB3203@xz-x1>
References: <20201019170519.1855564-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201019170519.1855564-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 19, 2020 at 01:05:19PM -0400, Paolo Bonzini wrote:
> Allowing userspace to intercept reads to x2APIC MSRs when APICV is
> fully enabled for the guest simply can't work.   But more in general,
> if the LAPIC is in-kernel, allowing accessed by userspace would be very
> confusing.  If userspace wants to intercept x2APIC MSRs, then it should
> first disable in-kernel APIC.
> 
> We could in principle allow userspace to intercept reads and writes to TPR,
> and writes to EOI and SELF_IPI, but while that could be made it work, it
> would still be silly.
> 
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

