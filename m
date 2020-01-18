Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206851419E8
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 22:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgARVmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 16:42:36 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45032 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726960AbgARVmg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jan 2020 16:42:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579383755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHxqhDP0TufZsymD5aBLz6SOYSXcOXPtS6AtVTuad0M=;
        b=Ynm/duSAhH8iE5ROyKcA1PA8/Cj9yJYTMTqswMfbUcrR1ov5d6sQlhqBVxaRhDVX0pjdrF
        Ca9RNHOiorpkcbM16j0o/GB8GlKCvfxsY/MbsEBbjl8WfrmZKh3tfLH1mQgmgfETDBKLfO
        JP4Gg8bIARMowJF+Hw4oe7yJs3krEXw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-WAZ5FbOXOvetjWoq4y9PDg-1; Sat, 18 Jan 2020 16:42:34 -0500
X-MC-Unique: WAZ5FbOXOvetjWoq4y9PDg-1
Received: by mail-wr1-f70.google.com with SMTP id i9so12139462wru.1
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 13:42:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xHxqhDP0TufZsymD5aBLz6SOYSXcOXPtS6AtVTuad0M=;
        b=M7QXdlrdzy7XUNiotjtsqNqXMEIE50IYbFKubzgXxfI1+5jcvMzDs4/NLEanS+YjRh
         a6lWtw6oFPpr8lp+TtF/WfYZuIf02zCkGsAoyuR/YSk4SFO+5zOlBTJZcejVQCLPiLcS
         DcpdHXhsbORKV6NoZofdwjr41n0+KVAKzzraZ139NcKWh8A+zs6o4VpkPLzrzR4+ipBP
         xjnRrba/fUfT6lwyVqbZgX4XpBEzsEAbnkZUqmULwSSyJoPst6E35m39I8dssViZ2Gn7
         TD8rm9Px19g/xt+/GbXuwzyksFsZoWb9kqjxrSHCndbSnfsVqABbbbJuuoPjfcVVwmiT
         e9Tw==
X-Gm-Message-State: APjAAAVX3U4LmlvzleMa6PsAugkJ2JpZAPfQzwa8uva7Ccx0NvA+pEP7
        W+ADluOw+neetHr3Lemsr6ymrm51CmKnp/J3ETtV3mXeqSAa2zRtfwUYMrnGsQM+XeDtwMTrLq/
        XhQg1cgOToClB
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr10039956wrr.312.1579383752264;
        Sat, 18 Jan 2020 13:42:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGeL3j5AKbJYgQGL57uc9lh0LouWQB0ofIhLiYd3qtAYLWTK27fNDU66fBia4y4941qRHntg==
X-Received: by 2002:adf:ff8a:: with SMTP id j10mr10039941wrr.312.1579383752058;
        Sat, 18 Jan 2020 13:42:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id u84sm5122120wmg.10.2020.01.18.13.42.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:42:31 -0800 (PST)
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
 <20200115232738.GB18268@linux.intel.com>
 <C6C4003E-0ADD-42A5-A580-09E06806E160@oracle.com>
 <877e1riy1o.fsf@vitty.brq.redhat.com>
 <20200116161928.GC20561@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0c3d32c1-7544-2370-f645-030bed55db83@redhat.com>
Date:   Sat, 18 Jan 2020 22:42:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200116161928.GC20561@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/20 17:19, Sean Christopherson wrote:
> Why not just do this in Qemu?  IMO that's not a major ask, e.g. Qemu is
> doing a decent amount of manual adjustment anyways.  And Qemu isn't even
> using the result of KVM_GET_MSRS so I don't think it's fair to say this is
> solely KVM's fault.

IMHO the features should stay available in case the guest chooses not to
use eVMCS.  A guest that uses eVMCS should know which features it cannot
use and not enable them.

Paolo

