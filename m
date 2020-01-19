Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55087141D18
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 10:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgASJJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 04:09:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33355 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbgASJJ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jan 2020 04:09:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579424997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IcajqUo+kfQ+f98QbjrFDlg5Ud72TmTMCsb6F4Fz4D4=;
        b=OmJ/DZVI37NS46RVa/EfcBbhjFkBaaopYPqcqqplrVUpnQDWII/l98YeNUu1Yy5kHzMWSV
        fkcw/ok2MIBcaGz+qqkVn7F1kesdBRhZj7NMn8/8wEnXduOAdTRbMc75NyVfhpHXxSm4pL
        tpODTHshzsGUFtxuB16ZJLyPsm5CPTQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-mZa80u1nM46bploBB5PsaQ-1; Sun, 19 Jan 2020 04:09:54 -0500
X-MC-Unique: mZa80u1nM46bploBB5PsaQ-1
Received: by mail-wr1-f71.google.com with SMTP id z10so12526167wrt.21
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 01:09:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IcajqUo+kfQ+f98QbjrFDlg5Ud72TmTMCsb6F4Fz4D4=;
        b=cbvF8ERftAlJiHT2Lt9PeI+/BV2tY5Qh712MMeaqpW/swrEe5IKJyOfZIDwCedoL7Q
         eh3j6p9x52fKfudqoWpDMHaSnSsqQScViKuztMyXb/ggakK17uGIFRsYFI5nNoUuPoJ9
         TqgPXl/gCA+HzZ/lm0qKxEooXpDLhw9X9jsMenN9lrdbx2puoEziKY9hYslXO5jTXbuD
         C3qmcXJyf4qEfIrBp65idYTuxfdQpS342enHn650F/5cZCN14O7066+yDrTLHryYi7by
         fIlxjxDzCXEArsnMmddkcjmviE1NiB6ensblEsSiLrYVBdckq4Wzo5h1uF25bv96FXj/
         kIpw==
X-Gm-Message-State: APjAAAXmax2Wpj7ZU3QOaGnxio/PlPhLVFMR1Bp081X8IF0FrSozRvhY
        40EpUaoM/HDWuqwgrpGUTGLtepZahKOtqKYCiFuP2UcMWzjevyS2WZ9sD0BXhGjN+9mT8tLDRRH
        CiAQ6wI83/eXA
X-Received: by 2002:a05:600c:24d1:: with SMTP id 17mr13129981wmu.136.1579424993429;
        Sun, 19 Jan 2020 01:09:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxejqAspGdTpRwVLTaue9sUqOEqUEKSOinDJ9+v1DAKUoJ13oye5QPQVqE5lCGt/X9ngbZwbg==
X-Received: by 2002:a05:600c:24d1:: with SMTP id 17mr13129956wmu.136.1579424993228;
        Sun, 19 Jan 2020 01:09:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id d8sm43179510wre.13.2020.01.19.01.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 01:09:52 -0800 (PST)
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
To:     Peter Xu <peterx@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <22bcd5fc-338c-6b72-2bda-47ba38d7e8ef@redhat.com>
Date:   Sun, 19 Jan 2020 10:09:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200109191514.GD36997@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/20 20:15, Peter Xu wrote:
> Regarding dropping the indices: I feel like it can be done, though we
> probably need two extra bits for each GFN entry, for example:
> 
>   - Bit 0 of the GFN address to show whether this is a valid publish
>     of dirty gfn
> 
>   - Bit 1 of the GFN address to show whether this is collected by the
>     user

We can use bit 62 and 63 of the GFN.

I think this can be done in a secure way.  Later in the thread you say:

> We simply check fetch_index (sorry I
> meant this when I said reset_index, anyway it's the only index that we
> expose to userspace) to make sure:
> 
>   reset_index <= fetch_index <= dirty_index

So this means that KVM_RESET_DIRTY_RINGS should only test the "collected
by user" flag on dirty ring entries between reset_index and dirty_index.

Also I would make it

   00b (invalid GFN) ->
     01b (valid gfn published by kernel, which is dirty) ->
       1*b (gfn dirty page collected by userspace) ->
         00b (gfn reset by kernel, so goes back to invalid gfn)
That is 10b and 11b are equivalent.  The kernel doesn't read that bit if
userspace has collected the page.

Paolo

