Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5511231B29
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 10:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgG2IX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 04:23:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:37696 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726737AbgG2IX0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 04:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596011005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8lrqZhx4wIlIKGfI1v+EKqO6jc0hqmda+j4PZMrvWEE=;
        b=izATLkqoGsmn4NG6MP7HxZydLZv+7lEfCEEwa7nofJYBi+idgLTcpHMgWzgWEP07esXa8C
        f5L9WvT7cLQ9N4h704UtbI0zELjZo0z6Hd67gptJjLBUcGkZejw7woN6ek+t+Ju1hvnVgn
        Sv/3byYdJZLX2gX2O05Gzf/+VF/RAKo=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-503-ftZZS5_ZPwyi0LUtVU8aog-1; Wed, 29 Jul 2020 04:23:23 -0400
X-MC-Unique: ftZZS5_ZPwyi0LUtVU8aog-1
Received: by mail-ej1-f72.google.com with SMTP id q9so8176495ejr.21
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 01:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=8lrqZhx4wIlIKGfI1v+EKqO6jc0hqmda+j4PZMrvWEE=;
        b=rFZB6WetZknlpO+orpm9zFEyFYbk7WdZERShcpNWJdZH+lrdYifpe8JuwtEPHaCXpg
         E4z1KCQ51J8iJt1wng66hGnRrsX2dg3cBmeFbU/DYeFwf4QL4Uipc1/ppL7Ae7BHaYy3
         Z2DO8O8hIjIB29IW1Q3wEK62/0foCQiKojg4z4sTuFKStxRVjgVQO+vf+fdrC5MvVLww
         u+EN2yxKV+2b06nasYwzFvv/AwiTVVNVTWnFdEAG6TZWGRlYeq2IvEAXDWBHkwsFaZ7j
         WuU0wJxivGd6xH8VY3sO4ZzWZpIveD1S8qb4s6Fo8NlIu0QXfwA31cZYnP5ipAXiqoYw
         Tt1w==
X-Gm-Message-State: AOAM532HXldoz4VLx32oCl+yZQHTsyMzj6rnyw6C1Hd2LegufcDUvE+k
        l6QhZhfvszPwGbOmVg1W7Jj2kY0N/g+B/aHJT5pumZqW4VXsXiOjhH6E5H4c/FJ7G867vj1OehG
        3lwF2KTqQKl9Q
X-Received: by 2002:a17:906:c096:: with SMTP id f22mr19924869ejz.159.1596011002577;
        Wed, 29 Jul 2020 01:23:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrtor48PKaJPzhZluQN3DnUZRQ0VogdZPOhAt3ZNs96b8Wg1nFDHyxjUTEMO1FmMqAUc0VVA==
X-Received: by 2002:a17:906:c096:: with SMTP id f22mr19924858ejz.159.1596011002411;
        Wed, 29 Jul 2020 01:23:22 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g9sm609366ejf.101.2020.07.29.01.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 01:23:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>, Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
In-Reply-To: <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
References: <20200728004446.932-1-graf@amazon.com> <87d04gm4ws.fsf@vitty.brq.redhat.com> <a1f30fc8-09f5-fe2f-39e2-136b881ed15a@amazon.com> <CALMp9eQ3OxhQZYiHPiebX=KyvjWQgxQEO-owjSoxgPKsOMRvjw@mail.gmail.com>
Date:   Wed, 29 Jul 2020 10:23:20 +0200
Message-ID: <87y2n2log7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Tue, Jul 28, 2020 at 5:41 AM Alexander Graf <graf@amazon.com> wrote:
>>

...

>> While it does feel a bit overengineered, it would solve the problem that
>> we're turning in-KVM handled MSRs into an ABI.
>
> It seems unlikely that userspace is going to know what to do with a
> large number of MSRs. I suspect that a small enumerated list will
> suffice.

The list can also be 'wildcarded', i.e. 
{
 u32 index;
 u32 mask;
 ...
}

to make it really short.

-- 
Vitaly

