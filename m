Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE953A1930
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhFIPWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:22:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230113AbhFIPWj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:22:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623252044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PicVeDSzjJZ/mxS+TZr8f7kpWvXfmAyXLh8N/PLr3hQ=;
        b=FSQeZP1LlH8fRB+7wEkGByJvelbAA26sEu5E6VnO05HaTCKk484fQw0Q8z9bSnVTyKX98E
        402xsCuViQlKj2JSYN0Q4vgY7JqHF1ttBgVl+y4qqdkMrf0Hm6h1rr3X/8vVeZGed6hxY1
        raaZW0x+r6FdP1X09xxXecbQxMSL2os=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-1riwScn4Nnmo535Sv3KkQw-1; Wed, 09 Jun 2021 11:20:43 -0400
X-MC-Unique: 1riwScn4Nnmo535Sv3KkQw-1
Received: by mail-wm1-f71.google.com with SMTP id z62-20020a1c65410000b0290179bd585ef9so844849wmb.7
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 08:20:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PicVeDSzjJZ/mxS+TZr8f7kpWvXfmAyXLh8N/PLr3hQ=;
        b=tofc+P+p8yo2q3Og0yFRGTTyflu7BKmFGs70WJl+ILqE41uOZq6Vpo6bFdnxpt0kiE
         8fR8YLfQdfjJVbq8sL9jyNYGbZC+YB++Daww/SI0pCcwJVsw4Xiu/SOqHAlzeXv8TNuV
         3qHPebcZOuS1bYUj1SEkdpck1t3/JkKkyOWFCJeHOwHnmhJ9cy1qcCiWxi1YfnOxbbYL
         3HAy4M0YkPXv/QmpJSLMPwtFMYAiZVTKM8E9h0fMIiT1nRSP7EKI7eiqIUqlYwZOOwlW
         ASgfVXHypg6lxmQ7Oyt4eGsnqG3I6XOqGbab+109zJKPffsmQZB19jNgWS0jvb9kdYpE
         pv7w==
X-Gm-Message-State: AOAM531z6Nwk4+nud+jTrXw44vWpXYfpKrhkTMPn1Q3C5cI7yuawtEPK
        dXLhEytxWwgK6esEkc6Xa7E2y0nkVc5GC4GtQRtOjQkifq45NQD99szkQ5jDrbROdmb+ukCpfYa
        gihRZG/42u4QL
X-Received: by 2002:a05:600c:19d3:: with SMTP id u19mr389683wmq.100.1623252042081;
        Wed, 09 Jun 2021 08:20:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUeEEwYkVR8QC7aBvWAjJFFsb6cPvIYtUmt8RzdHkXYWY8OazB5nxTKs/d19ZLhoyVa+icZg==
X-Received: by 2002:a05:600c:19d3:: with SMTP id u19mr389652wmq.100.1623252041769;
        Wed, 09 Jun 2021 08:20:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g21sm253830wrb.46.2021.06.09.08.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 08:20:41 -0700 (PDT)
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
References: <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <20210608190022.GM1002214@nvidia.com>
 <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
 <671efe89-2430-04fa-5f31-f52589276f01@redhat.com>
 <20210609115445.GX1002214@nvidia.com>
 <20210609083134.396055e3.alex.williamson@redhat.com>
 <20210609144530.GD1002214@nvidia.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <b9df3330-3f27-7421-d5fc-3124c61bacf3@redhat.com>
Date:   Wed, 9 Jun 2021 17:20:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609144530.GD1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 16:45, Jason Gunthorpe wrote:
> On Wed, Jun 09, 2021 at 08:31:34AM -0600, Alex Williamson wrote:
> 
>> If we go back to the wbinvd ioctl mechanism, if I call that ioctl with
>> an ioasidfd that contains no devices, then I shouldn't be able to
>> generate a wbinvd on the processor, right?  If I add a device,
>> especially in a configuration that can generate non-coherent DMA, now
>> that ioctl should work.  If I then remove all devices from that ioasid,
>> what then is the difference from the initial state.  Should the ioctl
>> now work because it worked once in the past?
> 
> The ioctl is fine, but telling KVM to enable WBINVD is very similar to
> open and then reconfiguring the ioasid_fd is very similar to
> chmod. From a security perspective revoke is not strictly required,
> IMHO.

I absolutely do *not* want an API that tells KVM to enable WBINVD.  This 
is not up for discussion.

But really, let's stop calling the file descriptor a security proof or a 
capability.  It's overkill; all that we are doing here is kernel 
acceleration of the WBINVD ioctl.

As a thought experiment, let's consider what would happen if wbinvd 
caused an unconditional exit from guest to userspace.  Userspace would 
react by invoking the ioctl on the ioasid.  The proposed functionality 
is just an acceleration of this same thing, avoiding the 
guest->KVM->userspace->IOASID->wbinvd trip.

This is why the API that I want, and that is already exists for VFIO 
group file descriptors, informs KVM of which "ioctls" the guest should 
be able to do via privileged instructions[1].  Then the kernel works out 
with KVM how to ensure a 1:1 correspondence between the operation of the 
ioctls and the privileged operations.

One way to do it would be to always trap WBINVD and invoke the same 
kernel function that implements the ioctl.  The function would do either 
a wbinvd or nothing, based on whether the ioasid has any device.  The 
next logical step is a notification mechanism that enables WBINVD (by 
disabling the WBINVD intercept) when there are devices in the ioasidfd, 
and disables WBINVD (by enabling a no-op intercept) when there are none.

And in fact once all VFIO devices are gone, wbinvd is for all purposes a 
no-op as far as the guest kernel can tell.  So there's no reason to 
treat it as anything but a no-op.

Thanks,

Paolo

[1] As an aside, I must admit I didn't entirely understand the design of 
the KVM-VFIO device back when Alex added it.  But with this model it was 
absolutely the right thing to do, and it remains the right thing to do 
even if VFIO groups are replaced with IOASID file descriptors.

