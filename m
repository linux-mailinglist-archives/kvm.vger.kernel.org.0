Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6787C3A2E18
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhFJO1u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 10:27:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231354AbhFJO1t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 10:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623335153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlw8yJtkAFcrBDUeJnOt7el2ElQfmLOcg/GBGss2Lyk=;
        b=SDDUj14boFUJXqdGKO6X+0FbcisaKgyOJWxGV2lG8D5VvN/N2Jzo+sYd445Z22/u0hfDn0
        JiXNyQuJabnhVhGOXV+RKDU7Ewxmvy29iR2UPr/hwPB+k6+IIo63SJv4kcySrzC+PkLE7Y
        5i4vB/6eMrWBvmTgDKBxEGNhmrCMnRc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-wR7flJ4bOPeUWeR5t8plQw-1; Thu, 10 Jun 2021 10:25:49 -0400
X-MC-Unique: wR7flJ4bOPeUWeR5t8plQw-1
Received: by mail-wm1-f69.google.com with SMTP id j6-20020a05600c1906b029019e9c982271so3941687wmq.0
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 07:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jlw8yJtkAFcrBDUeJnOt7el2ElQfmLOcg/GBGss2Lyk=;
        b=Ne6RqilHtORWci12fCqQRjnIBeMjivAv81Wm/0TEddewbP5aDsg4xRCOY1HtKclzec
         TBzV96AlXumorX46bUkUyaD0IkbkcuUIbnV9llrPavU1bsN1MuoHpC3sXzbPeZEm2PIm
         GY+k/3HgySXJ/bPoqnAAue4nwgLM6J4AudXXyytxoRSvGamox7TQGjVW+lrJ96KNv1Rt
         dmBmtEFcI0dNg+Vx0hPpo/bAZZk76Hcqtkfo+s5hKEkbHjWTyxNd58wt3Zvpeo1chOdV
         D0qqEPER5QWH6uJM1tGRBXUy/ICLiutFt9UR2IcR4XaqjxFmw/fopZsqohrLSNUIuteS
         n0Jw==
X-Gm-Message-State: AOAM532r0drM/QPXPTMHKPEUOukFJpIZONNb9y53ryq2iUsA19YvvUqB
        lwTsqm4CI8C1eiBvPdl1XcgD+oueh7vXGQcDIoWnIS3WMz0Y+Pnw+KVwNGlNkqZoDJcSAQSE1zG
        EHsM0xu/RUnjZ
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr5502717wmh.130.1623335148580;
        Thu, 10 Jun 2021 07:25:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJQjpOnEFDdWC9UjEeMGFejKfVxJvxj9bK0/M/4owCzVRyZDDory4hyxiohIvwHFzw1zdYiA==
X-Received: by 2002:a1c:ed03:: with SMTP id l3mr5502706wmh.130.1623335148408;
        Thu, 10 Jun 2021 07:25:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id b62sm3062861wmh.47.2021.06.10.07.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 07:25:47 -0700 (PDT)
Subject: Re: [PATCH 1/3 v4] KVM: nVMX: nSVM: 'nested_run' should count
 guest-entry attempts that make it to guest code
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org
References: <20210609180340.104248-1-krish.sadhukhan@oracle.com>
 <20210609180340.104248-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <60ea2bd0-ad4a-b979-9d80-080e7fafe534@redhat.com>
Date:   Thu, 10 Jun 2021 16:25:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609180340.104248-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 20:03, Krish Sadhukhan wrote:
> Currently, the 'nested_run' statistic counts all guest-entry attempts,
> including those that fail during vmentry checks on Intel and during
> consistency checks on AMD. Convert this statistic to count only those
> guest-entries that make it past these state checks and make it to guest
> code. This will tell us the number of guest-entries that actually executed
> or tried to execute guest code.
> 
> Also, rename this statistic to 'nested_runs' since it is a count.

Applied, but other statistics are also singular (l1d_flush, 
directed_yield_attempted) so I removed the renaming.

Paolo

