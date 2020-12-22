Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117BA2E1062
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 23:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgLVWur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 17:50:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726072AbgLVWur (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 17:50:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608677360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+qbneJ2jh3fYPKfa/u50B7CIQ8X0Uo7bpQgn3QfrgA=;
        b=FBWQxxK51oYVRB8g80DEwnzlITnvcUuUNWKEfYrPTJUHS4fwHRxjrUSwGC0Eh1PvXetifR
        +zvK4AfoZEWk9NXWPd1ruiF7f/NCh41HiUhTwuajuQhih5/VCxhX3ufAmRXhcAdGOaHUZp
        e7p4Ddwi+5g/ECHg+6jDjOSPpvniTLI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-5gt02H8cNbq07gnK80Oe6g-1; Tue, 22 Dec 2020 17:49:18 -0500
X-MC-Unique: 5gt02H8cNbq07gnK80Oe6g-1
Received: by mail-wr1-f71.google.com with SMTP id q18so11676393wrc.20
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 14:49:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n+qbneJ2jh3fYPKfa/u50B7CIQ8X0Uo7bpQgn3QfrgA=;
        b=lBkO8QvgVOLaTemQPudyWer//ig1csydy/NanDvjxZpEhgdDdqmoVkbpVib/UmApla
         0jhQE9U6Asr977kW9QiUL8NxU9WN3jis3KTWsPsPaNnKuzZtCJXwDUjo1p+YdwGtOYHT
         OO9xsbFbo2dem4ug0FmNBfR7TPz7SKbPNR1o0LQj3g2HjW6EkZoQpl1wny2vXgO1OtQf
         QpimDTpZ15sjqKSlOZEjyehV4+DHtG/md6WAa41VaKznHMotUIBwIIXnCsPC7kXdnBeW
         8OsjdIwD3HQFyw+D6hw+k1DEwhREg/RSZqcHpsz1ljFUhUfZfwXeGwQCVV7YT0pCfsi9
         WhSg==
X-Gm-Message-State: AOAM530dotV3BzTwYyS2zEs1218ZcKhKRISRt9fzvHxLURK3ZPrdV7wx
        qg/ckOG5enRtXyrRW8VzswT6ckFbzJs3U2lylStexcY+c2NPwCPLQUHEpnqi1pzBxRfEMZAzhH1
        hz+K8pWzfpU+z
X-Received: by 2002:a1c:7d94:: with SMTP id y142mr24010970wmc.105.1608677357489;
        Tue, 22 Dec 2020 14:49:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwS2fZRfRZ1tqO6mhPhZptW872NTdNoTC5rXieW8+2cgXm7VZ25VmkNgChwkfEp+tpsEJX+BQ==
X-Received: by 2002:a1c:7d94:: with SMTP id y142mr24010957wmc.105.1608677357295;
        Tue, 22 Dec 2020 14:49:17 -0800 (PST)
Received: from [192.168.1.124] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id z6sm27359812wmi.15.2020.12.22.14.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 14:49:16 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: fix shift out of bounds reported by UBSAN
To:     David Laight <David.Laight@ACULAB.COM>,
        'Sean Christopherson' <seanjc@google.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com" 
        <syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com>
References: <20201222102132.1920018-1-pbonzini@redhat.com>
 <X+I3SFzLGhEZIzEa@google.com>
 <01b7c21e3a864c0cb89fd036ebe03ccf@AcuMS.aculab.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <64932096-22a8-27dd-a8d6-1e40f3119db4@redhat.com>
Date:   Tue, 22 Dec 2020 23:49:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <01b7c21e3a864c0cb89fd036ebe03ccf@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/12/20 19:31, David Laight wrote:
>> 	/*
>> 	 * Use 2ULL to incorporate the necessary +1 in the shift; adding +1 in
>> 	 * the shift count will overflow SHL's max shift of 63 if s=0 and e=63.
>> 	 */
> A comment of the desired output value would be more use.
> I think it is:
> 	return 'e-s' ones followed by 's' zeros without shifting by 64.
> 

What about a mix of the two:

	/*
	 * Return 'e-s' ones followed by 's' zeros.  Note that the
	 * apparently obvious 1ULL << (e - s + 1) can shift by 64 if
	 * s=0 and e=63, which is undefined behavior.
	 */

Paolo

