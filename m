Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658C3125731
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 23:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfLRWtN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 17:49:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28655 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726512AbfLRWtN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 17:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576709351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nf6EXNQmn8TpdxJ/EIE1aLJ/0BdX93FyA2E4p7ENAvw=;
        b=WAqAO/4X2KSQYh8jLBa/4eqdOFXVtLlw+Fn9c9b82AMwvgkiQxg7FX9Cuqv8kiaNzkX8Zo
        5zGLyFf9DWdVvi/94wU+0PmVyzhRC/jrvgjveLnDwK+P+bbpaldVMqw5Id+2EolpM0gjcF
        fNmxUHA7xvLS5S1Yc+8J9Y+jqOAt1OU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-_y0SUUjhP1WdSmvXah4Z8A-1; Wed, 18 Dec 2019 17:49:10 -0500
X-MC-Unique: _y0SUUjhP1WdSmvXah4Z8A-1
Received: by mail-qt1-f199.google.com with SMTP id l4so2456316qte.18
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2019 14:49:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Nf6EXNQmn8TpdxJ/EIE1aLJ/0BdX93FyA2E4p7ENAvw=;
        b=L/7gMy684PyPhByMUdhV9dULMFU26Tgfy/Hst+dWgNVZNxUnMsOWBmK8dtW4UL4jFW
         Uzjws2HnOQLCUBWTiVy60M7e4cXz3GukZQfCSFVKAwbaSrj25w0qH9zbNF6GlDRyI4vV
         Q62I+qN+nloUN/s4OzuNV1CbgUJp9w+/Tj2ynjsAYSst6sUCFLl+XyHFFH9SdodFQ+9a
         CuWrTF9q5TZA+M6td7Vx2wW+RDeHQq1wVedMx7F1GmI0xzHZ9bkaq87XZIFJ9Tjx3x8v
         TN7igkqRdp4QEkd30WFEvidE6FimGN81GR2iW7sVPhLhUjtpTyrGgUXNguU7zG1MRbo0
         JPRA==
X-Gm-Message-State: APjAAAWc9/17Z87l9vTgkp8IWHl/pt8S6hTVaptxo4Or5+Zd3g88uUuU
        gZA4rFRWMuo0Wq3uyetfmFVr/mo/BcE1+qn3ulGdNQfok0LX5aiM4SntqC9d45Rb9cV3Et1EQMc
        97NaiqRFfsG2z
X-Received: by 2002:ae9:ea08:: with SMTP id f8mr4909960qkg.489.1576709349680;
        Wed, 18 Dec 2019 14:49:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqyJYEnTMcc5Qoc+53HJycTqW8W2yptSG0zaEwIAaR+VXvS1NKbEi6l+HjJNYWOy2aB23avJ/Q==
X-Received: by 2002:ae9:ea08:: with SMTP id f8mr4909944qkg.489.1576709349446;
        Wed, 18 Dec 2019 14:49:09 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id y7sm1207004qto.82.2019.12.18.14.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 14:49:08 -0800 (PST)
Date:   Wed, 18 Dec 2019 17:49:07 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191218224907.GF26669@xz-x1>
References: <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
 <20191216185454.GG83861@xz-x1>
 <815923d9-2d48-2915-4acb-97eb90996403@redhat.com>
 <20191217162405.GD7258@xz-x1>
 <c01d0732-2172-2573-8251-842e94da4cfc@redhat.com>
 <20191218215857.GE26669@xz-x1>
 <20191218222420.GH25201@linux.intel.com>
 <77b497c8-3939-58d1-166f-6c862d3a8d5b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <77b497c8-3939-58d1-166f-6c862d3a8d5b@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 11:37:31PM +0100, Paolo Bonzini wrote:
> On 18/12/19 23:24, Sean Christopherson wrote:
> > I've lost track of the problem you're trying to solve, but if you do
> > something like "vcpu_smm=false", explicitly pass an address space ID
> > instead of hardcoding x86 specific SMM crud, e.g.
> > 
> > 	kvm_vcpu_write*(..., as_id=0);
> 
> And the point of having kvm_vcpu_* vs. kvm_write_* was exactly to not
> having to hardcode the address space ID.  If anything you could add a
> __kvm_vcpu_write_* API that takes vcpu+as_id, but really I'd prefer to
> keep kvm_get_running_vcpu() for now and then it can be refactored later.
>  There are already way too many memory r/w APIs...

Yeah actuall that's why I wanted to start working on that just in case
it could help to unify all of them some day (and since we did go a few
steps forward on that when discussing the dirty ring).  But yeah
kvm_get_running_vcpu() for sure works for us already; let's go the
easy way this time.  Thanks,

-- 
Peter Xu

