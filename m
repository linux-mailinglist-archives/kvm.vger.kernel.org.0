Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0B1218C4B
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730259AbgGHPyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 11:54:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42725 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730116AbgGHPyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 11:54:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594223687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E2JylkmGqvhoOcb/shtzMuVZZ0krZeWRN5Y+vX9FU0o=;
        b=MESQW42edY11o/aThgKxGhTeKKSvpYNFVLgGb2/+7bWMu8SRyxI3Z9XsObTFkbBah/NDoj
        Mj7V/P87+VCBheWXXmIhNg1GKlyvIWhaII78cRWSSXNJ9QW8XfvhaJB25X80H9bgwSxUtY
        jbzZLH5GvbH0dB5kWvvDSfDUQkLWmZA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-RWtk2LpNOQu2WRXC-GtK0A-1; Wed, 08 Jul 2020 11:54:46 -0400
X-MC-Unique: RWtk2LpNOQu2WRXC-GtK0A-1
Received: by mail-wm1-f69.google.com with SMTP id g124so3408764wmg.6
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 08:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E2JylkmGqvhoOcb/shtzMuVZZ0krZeWRN5Y+vX9FU0o=;
        b=FHAD2xrz+ItwHKX5bFpdXcgTXK3dH+bLEPEnnlPIv8dgKRYXd46Ws4omKYVKqHhPW/
         2B1q+NPRHX/0IF4n+ZWaelPv5v79aXL07nwETk2cbF6QisImb0FSuAY/UBOHym4Mm2WC
         5AN9Onj7UJ2OMlxZa8qrXyc1OxrtuWOw/Jy5aZQwJNxu3vHNk9R2ziupgTC7kkyVUhfs
         F5sfNl4k/PMe5ejAo1Z5s1pAkp+lB5I04sStE5IUNxdCbV52LfkUKW/cInj8lYTzwFdM
         ZqGHQGTuTZmajXFqyBJ/MzQ3uEvXRpA5sMtoRv2YV+ARVdVFXIwMRzWlA3ivOvROqIBT
         Go+g==
X-Gm-Message-State: AOAM531f4y+2DjTSqUHaQZszJl9nDAeJE2WqHhSBnTHinIryUgUf/ihI
        uWjXrR89qzc1ALWv0z3UxQ5XvMNuyD+Q/ckv804W6PGtG1eoCTw24jebZuLrcX8zX98IrZN4lAv
        p6nW9F6YRyUar
X-Received: by 2002:a5d:6987:: with SMTP id g7mr58593724wru.79.1594223683451;
        Wed, 08 Jul 2020 08:54:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvVvPOE+KvsNAqExWUNOScSfevZpgbIsZWtSGnOuPcU9AGUIfgYqRiH7oZg2skleOLHt0eXA==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr58593709wru.79.1594223683271;
        Wed, 08 Jul 2020 08:54:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id n5sm253364wmi.34.2020.07.08.08.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 08:54:42 -0700 (PDT)
Subject: Re: [PATCH] KVM/x86: pmu: Fix #GP condition check for RDPMC emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20200708074409.39028-1-like.xu@linux.intel.com>
 <20200708151824.GA22737@linux.intel.com>
 <e285ccb3-29bd-dcb8-73d1-eeee11d72198@redhat.com>
 <20200708154520.GB22737@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <face99cd-f19d-afb3-8f5f-ac5206ba39b4@redhat.com>
Date:   Wed, 8 Jul 2020 17:54:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200708154520.GB22737@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 17:45, Sean Christopherson wrote:
> On Wed, Jul 08, 2020 at 05:31:14PM +0200, Paolo Bonzini wrote:
>> The order follows the SDM.  I'm tempted to remove the CR0 check
>> altogether, since non-protected-mode always runs at CPL0 AFAIK, but let's
>> keep it close to what the manual says.
> 
> Heh, it wouldn't surprise me in the least if there's a way to get the SS
> arbyte to hold a non-zero DPL in real mode :-).

I'm not sure if SMM lets you set non-zero SS.DPL in real mode.  It's one
of the few things that are checked with unrestricted guest mode so
there's hope; on the other hand I know for sure that in the past RSM
could get you to VM86 mode with CPL=0, while in VMX it causes vmentry to
fail.

It would be an interesting testcase to write for KVM, to see if you get
a vmentry failure after you set the hidden AR bytes that way and RSM...

Paolo

