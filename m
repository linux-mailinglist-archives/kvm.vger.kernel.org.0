Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091551A1DE3
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgDHJIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 05:08:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44392 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726965AbgDHJIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 05:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586336930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rUQ0HsWwrnHe34YtREcTfNzNUJOF3IAdDb38I5AaKxE=;
        b=itEESRTj8Om5ZYwi/41vWFHLEJ0IARFjEfitxIG5rJdBJ71HmmlSGlX4hx8/yjrZbfaVxc
        wr9AOJpCsPMPVttoDJHAS96xJeWO/8ldj3sH0mBQJLchuydSE2jOI+GAoAbN6WCP3tk1Zb
        v2M2kDyNQ/ZtN8I2IOzV/uo+pm8Q7QY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-xYrrIhXxNJWEYiSQqvgQHA-1; Wed, 08 Apr 2020 05:08:49 -0400
X-MC-Unique: xYrrIhXxNJWEYiSQqvgQHA-1
Received: by mail-wm1-f69.google.com with SMTP id f81so2091372wmf.2
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 02:08:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUQ0HsWwrnHe34YtREcTfNzNUJOF3IAdDb38I5AaKxE=;
        b=Ag4ep0t1tH639EISYj0efbGF+ORbHAOLSAMpykNGD8wCcgaE0NCstHPWYstV1Xz/ei
         LkgAT01LDF9NLjUvOAhbxTDOELEPAMlYYRmUAlAV+ffzxhvSBZXiZmv6AZGgMTNw2S3w
         qKFclGuzxX9UFGm95VLZ8EhGUGXpG6w30UlTwsXpyP5bMOlS1VNnSaYvmgseo3Imli6z
         RPbd5ucAG1ylSW0pmAfGXX4F9KBXOD1N69kpz7fctcxTmF2FJLKRW5K6Ps0/5V4X+L5h
         yrLu+Te6isuZL6aZRXPZ3026Zmwf13VAdqjIa7l7RGJtvtAegpsHYvfKsUBkkfbLoIQ3
         9OQA==
X-Gm-Message-State: AGi0PubNyrTjaGucFmu/h7i25mWwMnD4zE6FuksdmCcpYf5GUTOlSqKj
        e9nDRdl8I/lr3YFAC29TexIXwCAPCpc0W13PuysotdlykUCK+RbutsX4SyGb+FbI6jA4DVTBbxr
        zA+3wTwWz53sM
X-Received: by 2002:a7b:cd89:: with SMTP id y9mr3752574wmj.102.1586336928252;
        Wed, 08 Apr 2020 02:08:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypLe1s1nvra2eXvOVyXKoy+DeFW86EqO9pdanw+EMwQcEuocAwsAGqIDuWH/3Mfnb2xLGbG1mA==
X-Received: by 2002:a7b:cd89:: with SMTP id y9mr3752550wmj.102.1586336928006;
        Wed, 08 Apr 2020 02:08:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id s6sm5804360wmh.17.2020.04.08.02.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 02:08:47 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: s390: Return last valid slot if approx index is
 out-of-bounds
To:     Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+d889b59b2bb87d4047a2@syzkaller.appspotmail.com
References: <20200408064059.8957-1-sean.j.christopherson@intel.com>
 <20200408064059.8957-3-sean.j.christopherson@intel.com>
 <20200408091024.14a0d096.cohuck@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2701fd49-4cf8-2b2d-daa8-96945ea4f233@redhat.com>
Date:   Wed, 8 Apr 2020 11:08:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200408091024.14a0d096.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/20 09:10, Cornelia Huck wrote:
> On Tue,  7 Apr 2020 23:40:59 -0700
> Sean Christopherson <sean.j.christopherson@intel.com> wrote:
> 
>> Return the index of the last valid slot from gfn_to_memslot_approx() if
>> its binary search loop yielded an out-of-bounds index.  The index can
>> be out-of-bounds if the specified gfn is less than the base of the
>> lowest memslot (which is also the last valid memslot).
>>
>> Note, the sole caller, kvm_s390_get_cmma(), ensures used_slots is
>> non-zero.
>>
> This also should be cc:stable, with the dependency expressed as
> mentioned by Christian.
> 

So,

Cc: stable@vger.kernel.org # 4.19.x: 0774a964ef56: KVM: Fix out of range accesses to memslots
Cc: stable@vger.kernel.org # 4.19.x

Paolo

