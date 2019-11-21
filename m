Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F6B105091
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfKUKcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:32:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726623AbfKUKcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 05:32:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574332343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ElyN+sySj2vrmERpqpr9y3yrG2GGb+YKg2VUilmEol4=;
        b=HG7sNlNELlxuqMi8rN1ZJeYLTXUzCEL+FR+NPEfvm7P3cX4KyD7+LmGsVP+uNdWL7RsO9v
        DZx/c0rUzLr4e+mGE5KvLEUxEY7q0FqE+CGqGfJ61xnrkGeekMkL5KFK00wgOctwslqgRH
        yWqlQ3bjdHbjCMiB8scl+BoVjrB5bfA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-ty1wYyh7Oz60YuRFvzFozw-1; Thu, 21 Nov 2019 05:32:21 -0500
Received: by mail-wm1-f70.google.com with SMTP id y133so1333535wmd.8
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G440xlK0s+uloxeJR1VxHFZ4nRPuPOBSPLFeR2hRYM4=;
        b=CoTcrlhU8IJympIVKkypoFXCxafV2dDgyzhO1yprTXqQjg8+fO8eTOT06BlsXiKmqh
         +Oj6J3CslibmHsnBFHdZSgOWWJkVQhQ8CxM7l+wPPixd8W6dt9snR6XMqn2nMX4q0HhI
         O8VPaPQJbz4RVBjCW9RCODo8i7qOarWHgphcNDq6iXFOrLoYNdlwBlrpZN95Wu/q0/jf
         h368xM2yvbItkpKAMtjgQb+HyeqoWAr/6rNz63CzpC7Z1Dxkwox8sW8wjNfrMDB2de09
         jBee1K176TDDAgf+6SWmxg1V8riPsi8Ymv2UOkINjyJGkPew2KjpmAZy5+oHLMlUZz8q
         odQQ==
X-Gm-Message-State: APjAAAVf0JxQuhqlqgkDPM3k5/7IF0c54vMjNfakTSUJs+Q1RKsBUHCx
        SlRW7kxqxfhczWiB+IJCa5BNYx6e0zf/h+WtDOcKOpjhmjUcsa1V3HoAQBKFN5RU2708VbWkx5k
        DO7Fa9zpZDu8H
X-Received: by 2002:adf:978c:: with SMTP id s12mr9339802wrb.47.1574332340569;
        Thu, 21 Nov 2019 02:32:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqyKZh9kkJD8hfx2gvhV/y7La1WwVigFfE5/zMpUK4HVpNjGITyxTxnxC0ch0GWbElRX6dSUFg==
X-Received: by 2002:adf:978c:: with SMTP id s12mr9339763wrb.47.1574332340277;
        Thu, 21 Nov 2019 02:32:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id p15sm2359907wmb.10.2019.11.21.02.32.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:32:19 -0800 (PST)
Subject: Re: [PATCH v7 3/9] mmu: spp: Add SPP Table setup functions
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-4-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6898c9fe-6cd7-8820-78c0-9fc4969b48f1@redhat.com>
Date:   Thu, 21 Nov 2019 11:32:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-4-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: ty1wYyh7Oz60YuRFvzFozw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> +=09=09=09if (old_spte !=3D spp_spte) {
> +=09=09=09=09spp_spte_set(iter.sptep, spp_spte);
> +=09=09=09=09//kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +=09=09=09=09kvm_flush_remote_tlbs(vcpu->kvm);
> +=09=09=09}

Please do not leave commented code in the middle of the series.

Paolo

