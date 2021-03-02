Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA5932B5C1
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449327AbhCCHTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381335AbhCBU4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 15:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614718477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r1j8NMEhAgYTyBf1WiHgSfc0TUumNZ7UztixpClsp1g=;
        b=iEePYwyE/bskDI806OZmB6r/SarH9uHAIluzOU96E1BuSXY0c6jQWGYP0Fn07D5RUuUmnC
        PwzBQW5POTac9qfcMziHwolp0WbCLv71bczj/dA3ZtTwjJ1Q3oPh9imgFz9LAXcAxe0ihT
        kHDra0fzd82J6nO4Unpr0t8jWFiGPno=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-NNZ0eqbXMoO_xnSRfNYo2g-1; Tue, 02 Mar 2021 15:54:36 -0500
X-MC-Unique: NNZ0eqbXMoO_xnSRfNYo2g-1
Received: by mail-qt1-f198.google.com with SMTP id j25so10951795qtv.10
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 12:54:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r1j8NMEhAgYTyBf1WiHgSfc0TUumNZ7UztixpClsp1g=;
        b=XQP3Uj2v5Pfnh/A942OsJ/kbDv78633O8ZPTUW0LKn69a7EQ4hDpn6R8LdehLSMiMv
         4TE6LSrk1z79dAOIBEvCrUnayJ2b0pR8YY//NU43ArcrF2OEeQpsEparQaTuZn+uhpOl
         MxjF7Td9/jY35zc3tOfPdDwj3teglDw9fIw/dBt8XjsYSDfmhdSU0mouTUKosZqyIWkd
         ajb+IdUxeiRTzpqUBsItsGVXb4WnDT/F5vfhtYcUu3SExJ/tUlOTfyaTO7TQRfDLU4XC
         RMl3afYD0Ch9ry6sI21SPak5KNJf8qFalTKB44HvwDJEpgS9vwKI4DLW/WDCyGIcu8i5
         JAgQ==
X-Gm-Message-State: AOAM533tZS91CBrx7/dGri1QHPNFNSWCb5iozp3fbJ38JClCeOFS0vQ4
        B9NpV3FfEQjnnh5OH+kh9PX21YepPHaDZTd/KI55YfRrW4tpaGidu0iPLco0jqBOHBEiQ89tGMP
        qj9uKlUe3MAd+
X-Received: by 2002:a37:ab0f:: with SMTP id u15mr9741262qke.438.1614718475690;
        Tue, 02 Mar 2021 12:54:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeLa7exf65Sst/hfzfwtQs/1PH2WNwQVPCjrtJLfFvcsvwr7ln11WOQH1Etx3PH8jtyeZS7Q==
X-Received: by 2002:a37:ab0f:: with SMTP id u15mr9741240qke.438.1614718475456;
        Tue, 02 Mar 2021 12:54:35 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id l6sm5671096qke.34.2021.03.02.12.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 12:54:34 -0800 (PST)
Date:   Tue, 2 Mar 2021 15:54:32 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
Subject: Re: [PATCH v1 7/9] memory: introduce RAM_NORESERVE and wire it up in
 qemu_ram_mmap()
Message-ID: <20210302205432.GP397383@xz-x1>
References: <20210209134939.13083-1-david@redhat.com>
 <20210209134939.13083-8-david@redhat.com>
 <20210302173243.GM397383@xz-x1>
 <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <91613148-9ade-c192-4b73-0cb5a54ada98@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021 at 08:02:34PM +0100, David Hildenbrand wrote:
> > > @@ -174,12 +175,18 @@ void *qemu_ram_mmap(int fd,
> > >                       size_t align,
> > >                       bool readonly,
> > >                       bool shared,
> > > -                    bool is_pmem)
> > > +                    bool is_pmem,
> > > +                    bool noreserve)
> > 
> > Maybe at some point we should use flags too here to cover all bools.
> > 
> 
> Right. I guess the main point was to not reuse RAM_XXX.
> 
> Should I introduce RAM_MMAP_XXX ?

Maybe we can directly use MAP_*?  Since I see qemu_ram_mmap() should only exist
with CONFIG_POSIX.  However indeed I see no sign to extend more bools in the
near future either, so maybe also fine to keep it as is, as 4 bools still looks
okay - your call. :)

-- 
Peter Xu

