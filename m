Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7184A6B9FE
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 12:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfGQKW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 06:22:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35471 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfGQKW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 06:22:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so21569381wmg.0
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2019 03:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jLTb8XaQwDXkfXSX6rjJzVtQ/s+CDif4rrylvctVb1E=;
        b=IaCvhCuEVYehtPEPZXsXPCXXD/sXCK1EOm+rLKM1QzcsOENWXKVZUln9NDGBCLPay4
         4bNCaQoL+wpSQ3otQfYuJbmDhYQIZ0pIuKM6DgPhTR85W1TmSzk8ywCy9+oeaYFrsHya
         XJKwg7BrTa+jtW51vHeUDCDHmtCjJZlsEhUpfk5prm110OJntkFW08F3GJojNtom3vf6
         qSI1CX97fHGYLSVV/7ZvJSkAfXhHgvusPPnU2LVHfXSEDIks8GSdmhkKpP9CUIVBKnPR
         a2ER18+5rx8rDf37t2lbLxfEjv9sMEQT447MWThiX+GwycTRasqcQVqXrfT919O5AA1M
         Fdfw==
X-Gm-Message-State: APjAAAWGRW+OnXpzgm5PcEQpG8qyxfNXlyLbrQe1cpJvJ1VlA+YCOuBI
        6e0mgbxmxNfyk+YBF6qMKW7LAKePHWzoRg==
X-Google-Smtp-Source: APXvYqxg7asgftVlbHdDAy8AZswsqWfMo4yX1870wYoGzbxKjR9+cxc4Cqnn60F61CBtgD5q5kG7wg==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr4545813wmi.88.1563358945785;
        Wed, 17 Jul 2019 03:22:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id h133sm24198066wme.28.2019.07.17.03.22.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 03:22:25 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: PMU Event Filter
To:     Wei Wang <wei.w.wang@intel.com>,
        Eric Hankland <ehankland@google.com>
Cc:     rkrcmar@redhat.com, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, kvm@vger.kernel.org
References: <CAOyeoRUUK+T_71J=+zcToyL93LkpARpsuWSfZS7jbJq=wd1rQg@mail.gmail.com>
 <5D27FE26.1050002@intel.com>
 <CAOyeoRV5=6pR7=sFZ+gU68L4rORjRaYDLxQrZb1enaWO=d_zpA@mail.gmail.com>
 <5D2D8FB4.3020505@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5580889b-e357-e7bc-88e6-d68c4a23dd64@redhat.com>
Date:   Wed, 17 Jul 2019 12:22:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5D2D8FB4.3020505@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/19 10:49, Wei Wang wrote:
> {
>   KVM_PMU_EVENT_ACTION_GP_NONE = 0,
>   KVM_PMU_EVENT_ACTION_GP_ACCEPT = 1,
>   KVM_PMU_EVENT_ACTION_GP_REJECT = 2,
>   KVM_PMU_EVENT_ACTION_MAX
> };
> 
> and add comments to explain something like below:
> 
> Those GP actions are for the filtering of guest events running on the
> virtual general
> purpose counters. The actions to filter guest events running on the
> virtual fixed
> function counters are not added currently as they all seem fine to be
> used by the
> guest so far, but that could be supported on demand in the future via
> adding new
> actions.
> 

Let's just implement the bitmap of fixed counters (it's okay to follow
the same action as gp counters), and add it to struct
kvm_pmu_event_filter.  While at it, we can add a bunch of padding u32s
and a flags field that can come in handy later (it would fail the ioctl
if nonzero).

Wei, Eric, who's going to do it? :)

Paolo
