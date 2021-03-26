Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AA934AD28
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCZRM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:12:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230188AbhCZRMY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:12:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616778744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DIGcvJbUvG26Onz/7+nbdHpA1lLL+Gpem6I6C5hnz+I=;
        b=LqlAB7TTErNFSkPH2I5sUaU3EW+teBIa6md41Kykr5jUxrgmvRoRbr3iyuZ0x1ZuBsEAqG
        +Z4BDb88b1ToiJyMNQKOTOkCNYGy4IWl/SEYQsR/et/xIAjI/q5lAOge2XAwmgeMzHx773
        BuvBJ3N/GrzxIR/R0D1UanNgOUzKAYE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-k1t8Kc0JMG2vAtRk7TSeAA-1; Fri, 26 Mar 2021 13:12:20 -0400
X-MC-Unique: k1t8Kc0JMG2vAtRk7TSeAA-1
Received: by mail-ej1-f72.google.com with SMTP id a22so4348426ejx.10
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DIGcvJbUvG26Onz/7+nbdHpA1lLL+Gpem6I6C5hnz+I=;
        b=siqFKu9sCs4m3p2DB08ItTzUYyXGgc57C62TYLvrWerORd7SikUVA6a2tgDSlRqyZD
         vXLioS0563wEHhRR6uNhokawHdk7q+f08kwrNdLpm/CvYg0xTJWnLWh1YB3l1lz6JAV+
         K6TP7SQFENxgOGNT8JXNBVMdjVqwMQ59Rdp57Ozqy+DkvqDk1ZXB4FXR1zjrwXmOnYch
         bs3HZNq3QY/ehqI/I7sZIpbyvraD0nr8vhPy5oQB2fgMsYjw7Z8gR1IOzcaAHPm4968r
         J4ARaHGf967VFqfPRHds2/P8wDPeGL+G1/BkIX5nu98OXQYyXVh7d3TrM9xQWCjO3eKv
         y5Hw==
X-Gm-Message-State: AOAM531DkBT9jwCoZvEpH64jXpt7zwWKkmhTaxfC3XsdsrrRwGfzYwKS
        7LfkFnzjuV73iTbhPrwIbnWj0TUxzqSJbzkFJXIq7ZAH9AvrF1H39yGsBUX1JbKOd1B39m1Hh22
        voJtFKKDf9y8Z
X-Received: by 2002:a17:906:7102:: with SMTP id x2mr16822575ejj.355.1616778739233;
        Fri, 26 Mar 2021 10:12:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy++S5sPsaxk3N74zxpvkE10Iksv0V6S3Z9ojC8XJ8X8gUzJv2zRoT5RkKTG3St3RFKWFkjcA==
X-Received: by 2002:a17:906:7102:: with SMTP id x2mr16822567ejj.355.1616778739071;
        Fri, 26 Mar 2021 10:12:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h15sm4536905edb.74.2021.03.26.10.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:12:18 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Don't allow TDP MMU to yield when
 recovering NX pages
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210325200119.1359384-1-seanjc@google.com>
 <20210325200119.1359384-4-seanjc@google.com>
 <CANgfPd8N1+oxPWyO+Ob=hSs4nkdedusde6RQ5TXTX8hi48mvOw@mail.gmail.com>
 <YF0N5/qsmsNHQeVy@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ebcbf024-8bfa-c284-68ea-3b59709cb8d0@redhat.com>
Date:   Fri, 26 Mar 2021 18:12:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YF0N5/qsmsNHQeVy@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/21 23:25, Sean Christopherson wrote:
> I don't have a super strong preference.  One thought would be to
> assert that mmu_lock is held for write, and then it largely come
> future person's problem:-)

Well that is what I was going to suggest.  Let's keep things as simple 
as possible for the TDP MMU and build up slowly.

Paolo

