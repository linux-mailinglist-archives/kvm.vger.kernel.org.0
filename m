Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18B1EF2CC
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 10:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgFEIJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 04:09:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58534 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725986AbgFEIJa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 04:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591344569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrVbv0LAvfoDVrxdU1Wp4ZS7+oUmRvbMHHEQQfIJrYQ=;
        b=d+3Jq24POlPaVoQ7KymsVIV/Rhuxw2/ApIfFv0S0ho4BUCb90ZTkrJX5AywNBgbdiJLDOn
        cSj42Ww1KSVYkf59rYciRCENbkigy4JGN2LSskrarJfkyYdmyhxbINgvr32HY0sNP93Zg8
        rA86o8ykPdPq/JZGFW19yxFmuI/nVY0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-Y3FdP5IeN3W0-WqGMniAkA-1; Fri, 05 Jun 2020 04:09:27 -0400
X-MC-Unique: Y3FdP5IeN3W0-WqGMniAkA-1
Received: by mail-wr1-f70.google.com with SMTP id z10so3476517wrs.2
        for <kvm@vger.kernel.org>; Fri, 05 Jun 2020 01:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QrVbv0LAvfoDVrxdU1Wp4ZS7+oUmRvbMHHEQQfIJrYQ=;
        b=Fr5ZeOCOfKnAurPPc9chIyHX3LmqHehgFeGX076QFi+f67O/7eZAZRZwncPfgto1hH
         MCJX9LUepRoMEE8liExP2VadQVoGMUAq7OQraIDAY5dmyPU46foiyhEGQj31a7pXrCKs
         DViCIessK1zFvT3Jmns9MwwXZ8UMviO87CrPfaRc0rsTCEy7HTRClBgdCgEPpBffWnG+
         Wca/fsGa8QSH20U7iXC+uw983x9SwRvkdRMP8eoDpfipVDT3YvIW29bHpo9uGSMCfw8T
         uUIz7xOaJGj0I6+2qTZDLm6pDib5pbZKYDzJ7Zmj7nyD7Fq+qfQeRFf07yUhxTfcx2+W
         99+w==
X-Gm-Message-State: AOAM530Vq3iDQRWTIy/DAEsl27Zpjt2Arqj+ehCVtbGrvW68Ed98uGqe
        GDxd/3b/k2HaHSSqIm0xvqmKkf9ywZfJS8RP0R1ZuAvErqtGCDEzqVXbwMmB9vAOPzBtYHBFszi
        vdK7Ha4jBS5Ym
X-Received: by 2002:adf:910e:: with SMTP id j14mr3063155wrj.278.1591344566572;
        Fri, 05 Jun 2020 01:09:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIuVyoaDb2G7McATYKVs9RHDnOjJKTbctGFe7ylZ0JJN3Ab9BRicQxXsudMj+hwx2qABEvPw==
X-Received: by 2002:adf:910e:: with SMTP id j14mr3063139wrj.278.1591344566346;
        Fri, 05 Jun 2020 01:09:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id l18sm9796731wmj.22.2020.06.05.01.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 01:09:25 -0700 (PDT)
Subject: Re: system time goes weird in kvm guest after host suspend/resume
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
References: <87pnagf912.fsf@nanos.tec.linutronix.de>
 <87367a91rn.fsf@nanos.tec.linutronix.de>
 <CAJfpegvchB2H=NK3JU0BQS7h=kXyifgKD=JHjjT6vTYVMspY2A@mail.gmail.com>
 <1a1c32fe-d124-0e47-c9e4-695be7ea7567@redhat.com>
 <CAJfpegvwBx49j9XwJZXcSUK=V9oHES31zB2sev0xwS4wfhah-g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4c3c4a5a-e11b-1a27-0e25-9696e407bd0a@redhat.com>
Date:   Fri, 5 Jun 2020 10:09:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAJfpegvwBx49j9XwJZXcSUK=V9oHES31zB2sev0xwS4wfhah-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/06/20 09:35, Miklos Szeredi wrote:
>> time(2) instead should actually be gettimeofday(2), which just returns
>> tk->xtime_sec.  So the problem is the nanosecond part which is off by
>> 2199*10^9 nanoseconds, and that is suspiciously close to 2^31...
> Yep: looking at the nanosecond values as well, the difference is
> exactly 2199023255552 which is 2^41.

Umpf, I was off by 3, it's not related to 2^31.  But yeah the cause of
the bug seems to be the botched nanosecond part, which I'm sure is not
supposed to be much bigger than 10^9.

Paolo

