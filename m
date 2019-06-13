Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408C244A13
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfFMR7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:59:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52056 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbfFMR7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:59:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so3274741wma.1
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 10:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X2ZdLgjxab9G9OdwLapH+oQwWyPX+4510e889t1xHvc=;
        b=jTeAO2B9rvIxYzEGTYrvFRWqPIarzQpnv7c4CuRv2grarK5aeQA5pz9qgsp0XJ8X0n
         u20DzaTQgTKrtpioQYREq0PWctF86NpHQAe8JDUfns2R+ywlzg3HQ/qAvoHzXQuMwcML
         oUACrvUcF/BzrpJ7xDA/AA7swdqfdy27OGuYoRrAQKmhbjL9Lwt7HSGA8ov4iI+UJ8Av
         WUDUf4Pi1GtTr1eF6k6WWE/pgRXw+ZZPlVplkxp4VOYf6CY0OG2GlcrZZ4Xr5F8Z+5ix
         AL2xjzpLlNuGZxKHckkaBzr8i39UMXYWLv/Co7W+l1FHQBLmwVQlGVchFy++ZXpMYy0w
         DiVA==
X-Gm-Message-State: APjAAAWacTkSIvedSUi1+ml6shITxG0ZBdkOcDgpbT4oItOiPHimzBy6
        W/Ho3Ukfof1qsDwPDHtRcJZpcA==
X-Google-Smtp-Source: APXvYqyPjDOQTFPzIXYKvz5fSFrhNcefvCZw5GAeQuoOgkyppg9BIVx3c+GWFddFus6LA+KXbESm+g==
X-Received: by 2002:a05:600c:1008:: with SMTP id c8mr4802303wmc.133.1560448792196;
        Thu, 13 Jun 2019 10:59:52 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id y17sm790742wrg.18.2019.06.13.10.59.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:59:51 -0700 (PDT)
Subject: Re: [PATCH 1/7] KVM: nVMX: Intercept VMWRITEs to read-only shadow
 VMCS fields
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
 <20190507153629.3681-2-sean.j.christopherson@intel.com>
 <CALMp9eRb8GC1NH9agiWWwkY5ac4CKxZqzobzmLiV5FiscV_B+A@mail.gmail.com>
 <9d82caf7-1735-a5e8-8206-bdec3ddf12d4@redhat.com>
 <CALMp9eQU-OLnGX40=tCjYPWen5ee3rziMHQOTt7fyd1NVdaAsw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <354f636b-c26d-e053-78a7-e7880e708d5d@redhat.com>
Date:   Thu, 13 Jun 2019 19:59:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQU-OLnGX40=tCjYPWen5ee3rziMHQOTt7fyd1NVdaAsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/06/19 19:36, Jim Mattson wrote:
>> Also, while this may vary dynamically based on the L2 guest that is
>> running, this is much less true for unrestricted-guest processors.
>> Without data on _which_ scenarios are bad for a static set of shadowed
>> fields, I'm not really happy to add even more complexity.
>
> Data supporting which scenarios would lead you to entertain more
> complexity?

For example it would be interesting if some L1 hypervisor had 2x slower
vmexits on some L2 guests, but otherwise fits the current set of
shadowed fields.

Paolo

> Is it even worth collecting data on L3 performance, for
> example? :-)

