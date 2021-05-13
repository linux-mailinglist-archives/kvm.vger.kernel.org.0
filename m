Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D750537FB9F
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbhEMQhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 12:37:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231426AbhEMQhC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 12:37:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620923752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kZ77CPDQCWHApSin0O86NHXUuwmt8f5sZg8WC9FiUak=;
        b=S6kUTWZ5V0czPJiMiB0iXiuikqL2yLZQ6cABCWsjN+xapaDqoCJYb36pEElYzSbegleGPp
        rIBxmz1kOrJWywKco/9GkIkLJDYp3za87Wgurkpnm7p4F+k4nnaa3RMhJ65ZvZroNZl90/
        Ky0bjvppKnmBB+sB+y/ww13lRmrBDTI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-0PcrqlD2MUi7akjtyo7v6Q-1; Thu, 13 May 2021 12:35:48 -0400
X-MC-Unique: 0PcrqlD2MUi7akjtyo7v6Q-1
Received: by mail-ed1-f72.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so14917733edd.2
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 09:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kZ77CPDQCWHApSin0O86NHXUuwmt8f5sZg8WC9FiUak=;
        b=YRJtLr1rVsnrU7ehV4DkSMjLl8BhpnaTnTFwLz9tEfVKb5DoLVY2ozamoXUz4wc5bb
         uddmeeUHTBemUdkHjnYLxONXxW8OAwoPjF0M3UlW3AFJMa4qHditD95PpGAkQwoYtOMr
         atTGjMrdTZjheYEZ4w+Shcx1QmQN3fooYyUBWuIGAZX/iA5RY4D87Wl3pq2hXd3cA/NT
         42beUSOlWHL1j5SHM8Kk0Wol/Kk8hjtxbnwaUNmISOZfcrd2cF7GT2qhcMGPUMqvYsJu
         5+Z7uu/oA+ITOzGpDJFyIR3ZkmQtK/tizr5UyZ32N7fYYhYL/B4ozFFqEOez/Y27j1wp
         sAdg==
X-Gm-Message-State: AOAM530H0NI2LlAACNKdxaf1Rm13CcJ2Xdy3r8eu0ZW6Cj9nbIrwqs4j
        xe9WaTyqScz717RndTRutaZF39AMeXOnwFsHId/GnL4wgqm2ApcxfCR+VWYz7M+dh6dbZvv5p70
        6q8RvCSI4pfCb
X-Received: by 2002:a17:906:46d1:: with SMTP id k17mr693710ejs.77.1620923747338;
        Thu, 13 May 2021 09:35:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxS6Pt791axtI35PQLbrHu9L0hFxJm7VU4Ud3O66odghaW1DrdgeNPkrDDn/UEQrWtvK2AwDg==
X-Received: by 2002:a17:906:46d1:: with SMTP id k17mr693694ejs.77.1620923747140;
        Thu, 13 May 2021 09:35:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bn5sm2078704ejb.97.2021.05.13.09.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 09:35:46 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Don't dirty guest memory on every vcpu_put()
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>, kvm <kvm@vger.kernel.org>,
        Kevin Mcgaire <kevinmcgaire@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200116001635.174948-1-jmattson@google.com>
 <FE5AE42B-107F-4D7E-B728-E33780743434@oracle.com>
 <CANgfPd8wFZx977enc+kbbTP1DfMdxkbi5uzhAgpRZhU0yXOzKg@mail.gmail.com>
 <YJxf+ho/iu8Gpw6+@google.com>
 <CANgfPd8cujDpRBdD_XBC9h6Q8ijioXHuBUGZ-mBBGBAGHRBt6A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6bef99fe-b4ac-63fe-b9c2-d20b9ad7c5a9@redhat.com>
Date:   Thu, 13 May 2021 18:35:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd8cujDpRBdD_XBC9h6Q8ijioXHuBUGZ-mBBGBAGHRBt6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/05/21 18:14, Ben Gardon wrote:
>> A version of this was committed a while ago.  The CVE number makes me think it
>> went stealthily...
> That's great to know. Thanks for digging that up Sean.
> 

I usually try to send CVE/embargoed patches after the fact to the list, 
using an [FYI PATCH] prefix.

Paolo

