Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1664545322D
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 13:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236161AbhKPMbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 07:31:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236107AbhKPMbT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 07:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637065702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDBd4/MW5rp1mNYpqb4T94uUphKj/shx8I5wMfdqjiA=;
        b=LaliwAqvaP/XioTkOKiksKXzEN3CRYGMhGZ8egmPMyJh8fhOW2HYWeysu2GQJ3cbPa1jgp
        2Z9VDPO9dWya0MFZBkr1O/o2GKS5WytoPCh24WFFIVlmi8S6b5hT40YJZlEmd/JYL7Nkvh
        d5l4T+PcCAy449ZT7Uj9L+MlThaUx70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-lvd3M7liMQuIPkr15VIcsg-1; Tue, 16 Nov 2021 07:28:20 -0500
X-MC-Unique: lvd3M7liMQuIPkr15VIcsg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D394210151E6;
        Tue, 16 Nov 2021 12:28:19 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BF295BAE5;
        Tue, 16 Nov 2021 12:28:18 +0000 (UTC)
Message-ID: <42866023-7380-823d-c4c1-2fbf7b5d9527@redhat.com>
Date:   Tue, 16 Nov 2021 13:28:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: MMU: update comment on the number of page role
 combinations
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20211116101114.665451-1-pbonzini@redhat.com>
 <85599dcde5c8c6b74437fac28ebb62c38dafc6a8.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <85599dcde5c8c6b74437fac28ebb62c38dafc6a8.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 12:07, Maxim Levitsky wrote:
>> - * But, even though there are 18 bits in the mask below, not all
>> combinations
>> + * But, even though there are 20 bits in the mask
>> below, not all combinations
> I to be honest counted 19 bits there (which includes the 'smm' bit),
> but I might have made a mistake. I do wonder maybe it is better to
> just remove that comment with explicit number?

Yes, they are 19.  But the explicit number is there to guide in
understanding how 19 goes down to 14 combinations.

Here is a better writeup:

  *   - invalid shadow pages are not accounted, so the bits are effectively 18
  *   - quadrant will only be used if gpte_is_8_bytes is zero (non-PAE paging);
  *     execonly and ad_disabled are only used for nested EPT which has
  *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.
  *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
  *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
  *     paging has exactly one upper level, making level effectively redundant
  *     when gpte_is_8_bytes=0.
  *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if cr0_wp=0,
  *     therefore these three bits only give rise to 5 possibilities.

FWIW, the full count becomes 6400 unless I screwed up the math.

Paolo

