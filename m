Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8261C3FA2
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbgEDQRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:17:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34294 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729207AbgEDQRK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 12:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588609029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMOpMY0YQQxDGE9f6bszjh9mdyqywyqBT/HdaZYhvVA=;
        b=EqlAYXmrxWqot2LQ9TT9OBdFm9LuKtwh3XBXEB94qI7I6NslaSCb/9Owby/YsHF/54Evpp
        RJ0XGAnKbEMUTzEpzttqBOZ1hG/r8EcIpnkVWseBaQbQa9oWYX0aJo9Mayh//sMKfRxFRh
        8zreZTxI+SqGhdCv+MvoXBa3UDUISrk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-tlat6L_bOUGQv6zMTrQqtg-1; Mon, 04 May 2020 12:17:07 -0400
X-MC-Unique: tlat6L_bOUGQv6zMTrQqtg-1
Received: by mail-wr1-f69.google.com with SMTP id h12so508580wrr.19
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 09:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uMOpMY0YQQxDGE9f6bszjh9mdyqywyqBT/HdaZYhvVA=;
        b=gc6vWOFjQUegYTJaLzojaALDINUKk3keNnmJkCqxtcjHjOI7ajlLLGS9S1WSX4BOhE
         tAUUm19O3yzQsz9yrHH6TprXSCN67GyGGDAiAyXlh2SYNLEm9HolRT35+9VEePBYIKYQ
         L4BnHL3lhgwHElv8pH++W03CRqXgTK2IhDkLay/8+e102mq0DW00uAUvNrTtvi5yYbLY
         8+jgeP9WBtVZVnOf0eCwwhAbk+4P1yfv59Ug29514XANS/x/CvYK4/toerdJTBkZqGS1
         2hAFzrKjmYsQswEmuDY8OpMT5qRw7e/zvHbsk1ruu6ZpObevA8K7yX0ooymOscdKDOd8
         7j4Q==
X-Gm-Message-State: AGi0PuYWUg7y52ZVlBUjUIH82u0GW0D89mA3KmLmVMWt8p0AAkg89SoH
        lDLXk+wSaNYvVWdUL851jOgduJ1LGe1YQRpwq+j2pN+UNgLkXz+mKwLh/f41felYIQ4ERMjHhfC
        nsQAg0s6UBVka
X-Received: by 2002:a1c:b70a:: with SMTP id h10mr15654222wmf.172.1588609026564;
        Mon, 04 May 2020 09:17:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypKgIfENMjeXHov4dgLFDc1YKZsuljv/48zhE5QEqaw20gEpOMUq1qWoZAx/yY2/qjyGTCgIlA==
X-Received: by 2002:a1c:b70a:: with SMTP id h10mr15654201wmf.172.1588609026315;
        Mon, 04 May 2020 09:17:06 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id a205sm14990800wmh.29.2020.05.04.09.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:17:05 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Fixes posted interrupt check for IRQs delivery
 modes
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     joro@8bytes.org, jon.grimm@amd.com,
        Alexander Graf <graf@amazon.com>
References: <1586239989-58305-1-git-send-email-suravee.suthikulpanit@amd.com>
 <35c7c404406729dc05d0977c9d322655f2b1c4a9.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7b9e8091-d55b-5676-d5bf-c8bbe7ae171f@redhat.com>
Date:   Mon, 4 May 2020 18:17:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <35c7c404406729dc05d0977c9d322655f2b1c4a9.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/20 15:13, Maxim Levitsky wrote:
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>

Queued, thanks.

Paolo

