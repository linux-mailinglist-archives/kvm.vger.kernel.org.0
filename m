Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC4024D1AC
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 11:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgHUJol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 05:44:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgHUJok (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Aug 2020 05:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598003079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5xvNOCI/T24E9b4WJ3j1AFKLWyH8JLbOkVQBD24hcGw=;
        b=h0r2ogNE789jYzHt4uJPLGxiqNskJpoLrnHbUu/X+PVrzcRVH2DFLoU1qCIFo1NG/t4dT5
        C2CLB9/QstjcvXGHfxl21Y98xh0ZgbBGfryGy6jJS4eAq1nyZAZ0QVa0cIdhW3Omx1pBO0
        KTcMRdVaQq4S8JWe+xiH+T0JyjdLJhM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-n1Pl82HDNPy4kWqmRLnhPQ-1; Fri, 21 Aug 2020 05:44:37 -0400
X-MC-Unique: n1Pl82HDNPy4kWqmRLnhPQ-1
Received: by mail-wr1-f69.google.com with SMTP id t3so384300wrr.5
        for <kvm@vger.kernel.org>; Fri, 21 Aug 2020 02:44:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5xvNOCI/T24E9b4WJ3j1AFKLWyH8JLbOkVQBD24hcGw=;
        b=O79ACOfKkQwQ1XMKxtUuMXnNbV+4OREBRbj3IxeOWdC6zkl25KPtmL3BxnvnkZzK+V
         mapPkwUCwxXZ7AcTHRLKlpZ5J1vY6wI12mn4eu9WT/jvJK5FBcDEM5q0IXYvHKwOE0q2
         vXACpV/NUmk2oYdmfO16NfjHpoINkX7U3oiORgfsQka2UaBgJzTM+eLcl+Jc0/zTVYSq
         3U9w/RVPz7hMJf07kJwbjtZAWAdiBQrQPFl/6blkSHiKHycTDzxkof5FPlTm2nJPPZcF
         +mhEE25oNWYlzvbic++ljbe+nXcT8ZbsN3yRRn8n2JCHkUv56ZWHqzH86Xz19pxfJGMY
         mfzQ==
X-Gm-Message-State: AOAM532/pcofHoyy6kFTCwKAkq4BYN3L0cij7xLKSUgTCvb2U5GOwsR2
        7LRLBlxK9CbGx7dwuT3XU0RRR1fekTgEcIXaesngrY7Iect3KIZ//7RmN8Sda8aEeiHarhwladC
        4ySnVivYE0mCk
X-Received: by 2002:a1c:7918:: with SMTP id l24mr2908408wme.158.1598003075965;
        Fri, 21 Aug 2020 02:44:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6JglJ1VS+h/6tPMLaP2AyZuVQTrXmvTg3zqq1jBqyZgkSEMmoLY77Xi2H35dhd6C7SLIcIw==
X-Received: by 2002:a1c:7918:: with SMTP id l24mr2908394wme.158.1598003075764;
        Fri, 21 Aug 2020 02:44:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id k4sm3429929wrd.72.2020.08.21.02.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 02:44:35 -0700 (PDT)
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821074743.GB12181@zn.tnic>
 <3eb94913-662d-5423-21b1-eaf75635142a@redhat.com>
 <20200821081633.GD12181@zn.tnic>
 <3b4ba9e9-dbf6-a094-0684-e68248050758@redhat.com>
 <20200821092237.GF12181@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1442e559-dde4-70f6-85ac-58109cf81c16@redhat.com>
Date:   Fri, 21 Aug 2020 11:44:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200821092237.GF12181@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/08/20 11:22, Borislav Petkov wrote:
>> Hence the assumption that KVM makes (and has made ever since TSC_AUX was
>> introduced.
> And *this* is the problem. KVM can't just be grabbing MSRs and claiming
> them because it started using them first. You guys need to stop this. If
> it is a shared resource, there better be an agreement about sharing it.

It's not like we grab MSRs every day.  The user-return notifier restores
6 MSRs (7 on very old processors).  The last two that were added were
MSR_TSC_AUX itself in 2009 (!) and MSR_IA32_TSX_CTRL last year.

Paolo

