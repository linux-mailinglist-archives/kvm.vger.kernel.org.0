Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86786181FD8
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 18:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgCKRpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 13:45:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27609 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730500AbgCKRpQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Mar 2020 13:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583948715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AB8Xr/U170UK1wx2l/F+WJsKF1gpUCBlvtcUiwS4DKw=;
        b=KsgRMCmpMdUnQ7VwPZRF5uuZ7CzP4H5f0ILxlNOfUtOaYQuz3v/bHGzGdAbGWHot1URKB6
        cn8D3p+oDl9AsVRWPmXnDt1M2y12yZKwJiU/5V0VdLqfijxvgR9xqv+X8lsPBdvhQvl0cr
        EVUw0I6YkS6BK4mE/sw+395t2gTucjU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-B0r_7Qi9NbO37MJ4FRGPJw-1; Wed, 11 Mar 2020 13:45:14 -0400
X-MC-Unique: B0r_7Qi9NbO37MJ4FRGPJw-1
Received: by mail-qk1-f197.google.com with SMTP id 22so1988355qkc.7
        for <kvm@vger.kernel.org>; Wed, 11 Mar 2020 10:45:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AB8Xr/U170UK1wx2l/F+WJsKF1gpUCBlvtcUiwS4DKw=;
        b=qPeFJts8vwxDNoHb8NRRtzf9RgUOksCLypDqwAu09npC11ydDwtQqNloZAfrYb6hzx
         juZ/4Jt3UX9HbeZf34VVHBGwXyMVkj0/mH41LJ57c/Fu/atxcPC4YMufsqN69H4Px17P
         0NdSwkCm4/5Xy/s8Z72TsNSI47gcicX2BlFM/26tyF8DQVLm9/cTGrUfkfK9ULw4ta7G
         5Q3eshG7DyULWkgP0S7udusqZsM4xo3V408z0a7qXMOwEmUBi0Nzxvo5UM7u/Pdar7j5
         DNC4YZxta2cC99oaglzlkpUHMSwz6T/87y9lAbSKuhL9xp1VTy25I0xjSxJZCdAYQfuO
         bV/Q==
X-Gm-Message-State: ANhLgQ04IujVkvtzY4Ll1/CROSpu8AiYzLELD6muEhQ4U8GS+FABrxYG
        Of3O7++91QkqE6DgSG6pz4/wbKDjKy1KAcNabC+FlUFvZn2WvxQAqFHt0kG7JJMA6jbjd7wLtpR
        Ziy+SyV1T+0u0
X-Received: by 2002:a37:3c7:: with SMTP id 190mr3983854qkd.130.1583948713759;
        Wed, 11 Mar 2020 10:45:13 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvnvBW0KU19maXwWy9gbtSBb/6E4IjU2yQzpZ+WMaT2HfH/SpqJrH1c4nEHWDgV/4Uz0pUc3A==
X-Received: by 2002:a37:3c7:: with SMTP id 190mr3983828qkd.130.1583948713469;
        Wed, 11 Mar 2020 10:45:13 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 128sm863687qki.103.2020.03.11.10.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 10:45:12 -0700 (PDT)
Date:   Wed, 11 Mar 2020 13:45:10 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v6 13/14] KVM: selftests: Let dirty_log_test async for
 dirty ring test
Message-ID: <20200311174510.GJ479302@xz-x1>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309222534.345748-1-peterx@redhat.com>
 <20200310082704.cvmy6h4u7t2spncd@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200310082704.cvmy6h4u7t2spncd@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 09:27:04AM +0100, Andrew Jones wrote:
> >  enum log_mode_t {
> >  	/* Only use KVM_GET_DIRTY_LOG for logging */
> > @@ -156,6 +167,33 @@ enum log_mode_t {
> >  static enum log_mode_t host_log_mode_option = LOG_MODE_ALL;
> >  /* Logging mode for current run */
> >  static enum log_mode_t host_log_mode;
> > +pthread_t vcpu_thread;
> > +
> > +/* Only way to pass this to the signal handler */
> > +struct kvm_vm *current_vm;
> 
> nit: above two new globals could be static

Will do.

-- 
Peter Xu

