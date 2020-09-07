Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536A225F8DC
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728867AbgIGKwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 06:52:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43421 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728477AbgIGKwb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 06:52:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599475950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZNYuBpQt9HKowq473qvyGL7V94PMK5k48wA1l6+SwU=;
        b=XtllSTwmUAg3UlD4M7EHAHkDYqAx7ZUUOhLqQUobCfKNvQxOUD+thXUntA/m0Z47H37SQK
        /Lf8MrhT8bojsdWWNXmcSHP3G7wCvzmtrdp0BUrBQN2JPPR7A1NJI7O1RCT7PzJtQHAB7+
        S10Vq8Oy/ca3yI4+foeo3bD5YkeoVBE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-XdTr6BjjP5GhiJKyuwnXVg-1; Mon, 07 Sep 2020 06:52:28 -0400
X-MC-Unique: XdTr6BjjP5GhiJKyuwnXVg-1
Received: by mail-wm1-f70.google.com with SMTP id g79so4829400wmg.0
        for <kvm@vger.kernel.org>; Mon, 07 Sep 2020 03:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nZNYuBpQt9HKowq473qvyGL7V94PMK5k48wA1l6+SwU=;
        b=qCJ0JE+rANomhqcti96Oq6QnWSbfnIlGOapHBRnZ6PO1U0zTXWGIdt2dA/kTvXoeg2
         oaYSFQOc/Z9CvBplHgBMZXQEI/hYjkUHCWG3QlYzwhdzPdECClN3FgyyWnSxJLaJe5p3
         dN2vKIdYJ4WIWdHvFBdJ74d8GUasYKIElv2lmPR0wJ18gm9vQ0jVTKSuf6L+/Or9p8VK
         +e4pPVnmnOoIWW7UaJV0YFrtNZGf7Q9InM24w80xSMR6c3PYEPI3WOYGV9LTfk3+cJ41
         dwdymUe32bFH7NYvbOlQ/853wmx4F23Ll/+OFa8gOawlFafXIzh2qkxx0ilIg+r1TOh6
         yDqg==
X-Gm-Message-State: AOAM531wjWdlOe4WyjEtlCAPkUAlAAOPFO6l8UQiIp5XhTFB7BVbMmRI
        wzIiBIfSaSUd+lGMJBZ69voGItHC7rDS+wX6xyZPwKf9Fwvv8bCOQm4u6sTFj5SsQ6nW1lwbQga
        mZKskwo1j8XNe
X-Received: by 2002:adf:e292:: with SMTP id v18mr2295014wri.256.1599475947654;
        Mon, 07 Sep 2020 03:52:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG5yHsS/XQWDRSHn7G2xKTYdTMeb9QBkBBhYcA+QxqmG74U+oeLI7TfgtvmkrDWtQwwtMcjA==
X-Received: by 2002:adf:e292:: with SMTP id v18mr2294999wri.256.1599475947455;
        Mon, 07 Sep 2020 03:52:27 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id a74sm28019641wme.11.2020.09.07.03.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:52:25 -0700 (PDT)
Date:   Mon, 7 Sep 2020 06:52:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200907065054-mutt-send-email-mst@kernel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200825212526.GC8235@xz-x1>
 <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
 <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 09:29:05AM +0200, Gerd Hoffmann wrote:
>   Hi,
> 
> > Unless I'm mistaken, microvm doesn't even support PCI, does it?
> 
> Correct, no pci support right now.
> 
> We could probably wire up ecam (arm/virt style) for pcie support, once
> the acpi support for mictovm finally landed (we need acpi for that
> because otherwise the kernel wouldn't find the pcie bus).
> 
> Question is whenever there is a good reason to do so.  Why would someone
> prefer microvm with pcie support over q35?

The usual reasons to use pcie apply to microvm just the same.
E.g.: pass through of pcie devices?

> > If all of the above is true, this can be handled by adding "pci=lastbus=0"
> > as a guest kernel param to override its scanning of buses.  And couldn't
> > that be done by QEMU's microvm_fix_kernel_cmdline() to make it transparent
> > to the end user?
> 
> microvm_fix_kernel_cmdline() is a hack, not a solution.
> 
> Beside that I doubt this has much of an effect on microvm because
> it doesn't support pcie in the first place.
> 
> take care,
>   Gerd

