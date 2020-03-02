Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544841762DE
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 19:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgCBSkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 13:40:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727412AbgCBSkd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 13:40:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583174431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1X0PQLF6NwaqQ0Dzv48A0q1FZz95BzWsFQZPymTOR4A=;
        b=TltPo9rWMvjApVCQZ68UK7aBQGjZ2Gqql74arRbuxOs5ArNIo2DF2JFOmw9rBBP8Mp3Haa
        JMFTloWvovkooL9DUATvMO9BnCoewY2Zdad1RIVosXweW4nPWXfJ5HZ+wGYVKOVTmZpMeT
        SXXHJ+KyYIb/mgfyzugyINqWdWet6x0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-MFBOnHo6POuQaWgLB-hwUg-1; Mon, 02 Mar 2020 13:40:30 -0500
X-MC-Unique: MFBOnHo6POuQaWgLB-hwUg-1
Received: by mail-wr1-f72.google.com with SMTP id f10so99100wrv.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 10:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1X0PQLF6NwaqQ0Dzv48A0q1FZz95BzWsFQZPymTOR4A=;
        b=Aiy8GMkBM8LSraa8v8i1bwgThZmGSC9gVbqBDtow+slUsjUhyC081aWN+xCU73Q87U
         EA1QWEbxNLUWiS8PSW26tmx3C67eZYz8Air100ePtbmulx+q8w3NDsplkJs23eHmxIc8
         qw9CKHWhkCo/sfrMYUZYM4xe2fF20Ty04RJFQtrlTM8meFvLoFSmZODYnwfkcqoyvKoA
         3xiF9z325exy+Lq24tJ+eu90I7MU6dWYGZbAHC2lbwYCUcuWe9Gp6dylaWlE4Y5itqA/
         Cwyt+VhXJPfKFfqt1rs8wGC9ObH5Yaf1S1QCLL5y0mQtZVs/TJSz7MIxejbo3ZXY82Yj
         cs8A==
X-Gm-Message-State: ANhLgQ3KJVWg+Q1VBRgO5hnFHCzn14tZIDgxU/JHGAPUPkHV8FqxX2DN
        OS/zSEla2DrZDOqKMXP0wxAvDPYVPmc7UtA2bMkOO+fYQ3ZVctPjIw+a0v+k4KK8BWZxtxcXfB+
        UPdpA1CL2uN08
X-Received: by 2002:a1c:7907:: with SMTP id l7mr343894wme.37.1583174429142;
        Mon, 02 Mar 2020 10:40:29 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvwC0ey9J226DWJuc8knmd1FpRwvKZZlAuQKol2FcrrUa/BQT+AdmMNebVCCPpOKiNw/O24wA==
X-Received: by 2002:a1c:7907:: with SMTP id l7mr343883wme.37.1583174428928;
        Mon, 02 Mar 2020 10:40:28 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id b12sm1049163wro.66.2020.03.02.10.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 10:40:28 -0800 (PST)
Subject: Re: [PATCH v2 10/13] KVM: x86: Shrink the usercopy region of the
 emulation context
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-11-sean.j.christopherson@intel.com>
 <87r1yhi6ex.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <727b8d16-2bab-6621-1f20-dc024ee65f10@redhat.com>
Date:   Mon, 2 Mar 2020 19:40:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87r1yhi6ex.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/02/20 18:51, Vitaly Kuznetsov wrote:
>> +
>> +	/* Here begins the usercopy section. */
>> +	struct operand src;
>> +	struct operand src2;
>> +	struct operand dst;
> Out of pure curiosity, how certain are we that this is going to be
> enough for userspaces?
> 

And also, where exactly are the user copies done?

Paolo

