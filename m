Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0668741584C
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 08:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239382AbhIWGiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 02:38:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239312AbhIWGh5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 02:37:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632378985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BpRl3ktTmfUHJQChKKvJO7RT2jCwywVDHGvSYX38WaU=;
        b=fuIByrMeOJIkCqI5nnkJmNwax9Jg0pKDK/a7WKYEvmFKGZdvlbohuafHN6v0OosJJISq/U
        phy6hcaVY6IMDKWTEUOlLx/zxblJb6vyJdiqVZvUP0K/8nEPqaNXefBDp9y7jmcXbrjoYL
        49OdC2cYqHNgE1hi3wqLDw6BXMH8U3I=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-JHRxaYgkPqi_jGU_NXHjLw-1; Thu, 23 Sep 2021 02:36:24 -0400
X-MC-Unique: JHRxaYgkPqi_jGU_NXHjLw-1
Received: by mail-ed1-f69.google.com with SMTP id 2-20020a508e02000000b003d871759f5dso5780910edw.10
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 23:36:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BpRl3ktTmfUHJQChKKvJO7RT2jCwywVDHGvSYX38WaU=;
        b=cXHQtyzOop3Kld64emlhOFTFSHR7ulcW55gE5Vj8M84Otc9gty/Gt5jhk4rB9E2W3E
         bSs7ttNDCklAVva2ZVXRwb+pQh0Nr0zNsHhYBirRfp4eXbvn4gFbdZF0f9Ije4Dfl5qd
         +HyMc1caibiPgTjXCt+Mv3m8AzpAseuaXzLAUEvMh46ojKGcOdRkYxHd37vPsjXawbu5
         mx3b2cgfy5oVeZco4rGNoxnyoF9Ktlttf57wvP+0Trh9IWHrS8gQ7PLKNP4Jr233enoZ
         fTOJhD2HIpgh59kSlF1o9GKXyNKpxu4gTSlqb91cKD7leivEVnU8wvzZC27Y7Tf3NPX/
         BA8A==
X-Gm-Message-State: AOAM533bLDRNU8dM3F+zZtLikPiPQCbHVPyYy60j+LG/E4CHD8ycLWek
        boyTL9e2FCmyGrDrf7c6VzYkL/A+6kVnxzhI1jQcWK623icCuoJWbVenElOelB5V6PrqhTKhhZ6
        8L2bWfD16YFxQ
X-Received: by 2002:a50:cd9d:: with SMTP id p29mr3720569edi.30.1632378983300;
        Wed, 22 Sep 2021 23:36:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6sZGyumEooB67Yh4xUEZVzihaXUP8VPx9KEAKK3nYB6vOFaIoZiqKnq0MxX6rIHNLDqioeQ==
X-Received: by 2002:a50:cd9d:: with SMTP id p29mr3720550edi.30.1632378983068;
        Wed, 22 Sep 2021 23:36:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id hz15sm2344103ejc.119.2021.09.22.23.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 23:36:22 -0700 (PDT)
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
To:     Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
 <YUtyVEpMBityBBNl@google.com> <875yusv3vm.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a1e77794-de94-1fb7-c7d3-a80c34f770a4@redhat.com>
Date:   Thu, 23 Sep 2021 08:36:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <875yusv3vm.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 20:53, Marc Zyngier wrote:
> I definitely regret adding the current KVM trace points, as they
> don't show what I need, and I can't change them as they are ABI.

I disagree that they are ABI.  And even if you don't want to change 
them, you can always add parameters or remove them.

Paolo

