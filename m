Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A6F1EEB9E
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 22:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbgFDUOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 16:14:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52372 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728565AbgFDUOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 16:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591301657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nfjJTqzLy4RB96gNpe7W2IyNFqvkTW8Rkb74loa30+g=;
        b=b5L5JtKLbASqoGpCQ3Y3XBnYCiTGjywYalTFv+OcHXDt9/QAKJwf/55ggolqH1eZkWcikJ
        P1U4fpFDCoWPcAvIQTuUi2hSxmXScMyx2RHKJ2I87fwhRTGo5LTgNrYRfxw5h0gw/vJDvE
        OrJX/BdkeXkKBHp42MGdiubIDzjOFf8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-exYmOWKqPLqDt_tkla3lJQ-1; Thu, 04 Jun 2020 16:14:15 -0400
X-MC-Unique: exYmOWKqPLqDt_tkla3lJQ-1
Received: by mail-wr1-f71.google.com with SMTP id p10so2856441wrn.19
        for <kvm@vger.kernel.org>; Thu, 04 Jun 2020 13:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nfjJTqzLy4RB96gNpe7W2IyNFqvkTW8Rkb74loa30+g=;
        b=cRL09kwNg5GU1lTd40GGVIu3lDF/iJnmz3HU5qkIFKDSgbbMYTDEgrTq6Bhk5e/DOu
         t1veuNNEujkxL5p3Me75v+EIHkMl7LDoO07YAevdkfj5g1PLgYAPCIPETitma5dn991g
         8bdF1RJzMruOjB52IBbsPPcB1kskU+Tvwbnm0er+wUAKKwUT+5ViZzmLll/MMR9vD7dL
         +6wYRpwLOve6OZ0tW819a9taFAX1gJty+5WLHWQgTUkdBGePQ7Eo/voz8jDbGWvbO1DZ
         3cir0ecIoToZ7zTgdyNzAkH2uVqLYP/1ctpCgTErYUFn3+nOIaBZHIHjoWHxTzVSV7yK
         s76w==
X-Gm-Message-State: AOAM530oVPfs1p+yduheyXFde9PLpRZMAwx6tYNsQoTmEeCMb81JWcW5
        cRj7AqKl09/5gcIMV9Zz0zg1+AlzXAW5kT5NZgaA+3RqUWsG/6lbJs5Sz3bdxliXWIFi/tbk5pH
        etheoMX1ndVnG
X-Received: by 2002:a1c:143:: with SMTP id 64mr5868249wmb.182.1591301653819;
        Thu, 04 Jun 2020 13:14:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLHVFWDumGFiXykNBmg7FRXYUzyB+TNWC5L35KaMz1P9rEjS+HApHOpLXnjqNudr2XW8Rj7g==
X-Received: by 2002:a1c:143:: with SMTP id 64mr5868239wmb.182.1591301653533;
        Thu, 04 Jun 2020 13:14:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a0c0:5d2e:1d35:17bb? ([2001:b07:6468:f312:a0c0:5d2e:1d35:17bb])
        by smtp.gmail.com with ESMTPSA id l2sm9072625wru.58.2020.06.04.13.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 13:14:12 -0700 (PDT)
Subject: Re: system time goes weird in kvm guest after host suspend/resume
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm@vger.kernel.org, Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org
References: <87pnagf912.fsf@nanos.tec.linutronix.de>
 <87367a91rn.fsf@nanos.tec.linutronix.de>
 <CAJfpegvchB2H=NK3JU0BQS7h=kXyifgKD=JHjjT6vTYVMspY2A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a1c32fe-d124-0e47-c9e4-695be7ea7567@redhat.com>
Date:   Thu, 4 Jun 2020 22:14:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAJfpegvchB2H=NK3JU0BQS7h=kXyifgKD=JHjjT6vTYVMspY2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/20 21:28, Miklos Szeredi wrote:
> time(2) returns good time, while clock_gettime(2) returns bad time.
> Here's an example:
> 
> time=1591298725 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> time=1591298726 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> time=1591298727 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> time=1591298728 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> time=1591298729 RT=1591300383 MONO=39582 MONO_RAW=39582 BOOT=39582
> 
> As you can see, only time(2) is updated, the others remain the same.
> date(1) uses clock_gettime(CLOCK_REALTIME) so that shows the bad date.
> 
> When the correct time reaches the value returned by CLOCK_REALTIME,
> the value jumps exactly 2199 seconds.

clockid_to_kclock(CLOCK_REALTIME) is &clock_realtime, so clock_gettime
calls ktime_get_real_ts64, which is:


        do {
                seq = read_seqcount_begin(&tk_core.seq);

                ts->tv_sec = tk->xtime_sec;
                nsecs = timekeeping_get_ns(&tk->tkr_mono);

        } while (read_seqcount_retry(&tk_core.seq, seq));

        ts->tv_nsec = 0;
        timespec64_add_ns(ts, nsecs);

time(2) instead should actually be gettimeofday(2), which just returns
tk->xtime_sec.  So the problem is the nanosecond part which is off by
2199*10^9 nanoseconds, and that is suspiciously close to 2^31...

Paolo

