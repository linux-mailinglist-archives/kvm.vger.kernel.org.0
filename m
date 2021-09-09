Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D43C405EAF
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 23:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345085AbhIIVTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 17:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhIIVTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 17:19:50 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC6DC061756
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 14:18:40 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id f6so2877473vsr.3
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 14:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/E/8smJUHTBplUsRlZBuIUX4K9eK50NLheqbrKIzOMA=;
        b=bssITox5qc/lCDCeF8R7HDzSPA21Bum0LW1yVbEsMTcqDR5xerO1F49EIZTt5i4hAO
         uLes0QE6PfOR+C+h/i4Bn72vhh5sjNSBrdPKMVPjb2zn4zUazwal8QWYZgLf/biiQIPR
         aJwsJSz8t+K1Y9eezczxAZQtWmc4C+tTVQLUgquqVVDYWc+zQ7DUgAdn2VQXBgEx49bT
         l6ihG0i+WZlEtE9Uk22h23hhITZHehdjoqhg3SkhOEiFlz5fNNXid+r/jk9c/RaRuaNf
         kU1s9nhTJi2jgPUMt0J8UjV9svIFbnh3iCKCZEJXT3wrdlCyvtM+v3vvCBUbZhH/qHFp
         1lTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/E/8smJUHTBplUsRlZBuIUX4K9eK50NLheqbrKIzOMA=;
        b=3TuHiDVkGdAAhxOaxSBCo8VgfSEyJzV3L9sFAc1a2gG32JeFxeYBHBsJulJ/vVCD/G
         dr8dSkyHbl2kpMgkjIfWu3FNKG5Zy6xz0996kRr4mGJgLNhSxZRPJydzG4bqB0KaIwix
         KQXEfjM54hvQcUqdiEuo3vmjt0VcBDR+9IRSqFy/pqbSBJU3ae9bHiReVAGEE0scgI+/
         N8awNLaLsBsnf6u4M9R8l9FihiRKrki2rBih+D7fd3lkWp61aiXOljr0xd6HZt01Ti6+
         l6umOAgty6tApzQbIA5A5UsfmrMnaa5Ks45SHNpx+EzapvAGZrhD7rWv2XpQAJM6+zxg
         jGvQ==
X-Gm-Message-State: AOAM530zFTwFf7HuukBOfO6O5d7tP/BQz6Hk9qBQ4ibXr2qexRHNgLiH
        TfSNTLo6aKx4jtkdPaJUYuW0oSATNpZdWnXDSkg/YA==
X-Google-Smtp-Source: ABdhPJwaw3fj4RW2mYYYaHq8r3mCngNKf5j/vOsNg0pxRS2SMxe8BP1fJ+TSXjOXVdkXzYXeUr7Uk5/cjhgtMqgCWtg=
X-Received: by 2002:a67:fdd1:: with SMTP id l17mr3617799vsq.47.1631222319252;
 Thu, 09 Sep 2021 14:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210818053908.1907051-1-mizhang@google.com> <20210818053908.1907051-4-mizhang@google.com>
 <YTJ5wjNShaHlDVAp@google.com> <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com>
 <YTf3udAv1TZzW+xA@google.com> <8421f104-34e8-cc68-1066-be95254af625@amd.com> <YTpOsUAqHjQ9DDLd@google.com>
In-Reply-To: <YTpOsUAqHjQ9DDLd@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 9 Sep 2021 14:18:28 -0700
Message-ID: <CAL715W+u6mt5grwoT6DBhUtzN6xx=OjWPu6M0=p0sxLZ4JTvDg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
To:     Sean Christopherson <seanjc@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Most of the address field in the "struct sev_data_*" are physical
> > addressess. The userspace will not be able to populate those fields.
>
> Yeah, that's my biggest hesitation to using struct sev_data_* in the API, it's
> both confusing and gross.  But it's also why I think these helpers belong in the
> PSP driver, KVM should not need to know the "on-the-wire" format for communicating
> with the PSP.
>

Did a simple checking for all struct sev_data_* fields defined in psp-sev.h:

The average argument is roughly 4 (103/27), detailed data appended at
last. In addition, I believe the most used commands would be the
following?

#data structure name: number of meaningful fields
sev_data_launch_start: 6
sev_data_activate: 2
sev_data_decommission: 1
sev_data_receive_update_data: 7
sev_data_send_update_vmsa: 7
sev_data_launch_measure: 3
sev_data_launch_finish: 1
sev_data_deactivate: 1

For the above frequently-used command set, the average argument length
is also around 3-4 (28/8) on average, 2.5 as the median.

So, from that perspective, I think we should just remove those
sev_data data structures in KVM, since it is more clear to read each
argument.

In addition, having to construct each sev_data_* structure in KVM code
is also a pain and  consumes a lot of irrelevant lines as well.

#data structure name: number of meaningful fields
sev_data_deactivate: 1
sev_data_decommission: 1
sev_data_launch_finish: 1
sev_data_receive_finish: 1
sev_data_send_cancel: 1
sev_data_send_finish: 1
sev_data_activate: 2
sev_data_download_firmware: 2
sev_data_get_id: 2
sev_data_pek_csr: 2
sev_data_init: 3
sev_data_launch_measure: 3
sev_data_launch_update_data: 3
sev_data_launch_update_vmsa: 3
sev_data_attestation_report: 4
sev_data_dbg: 4
sev_data_guest_status: 4
sev_data_pdh_cert_export: 4
sev_data_pek_cert_import: 4
sev_data_launch_start: 6
sev_data_receive_start: 6
sev_data_launch_secret: 7
sev_data_receive_update_data: 7
sev_data_receive_update_vmsa: 7
sev_data_send_update_data: 7
sev_data_send_update_vmsa: 7
sev_data_send_start: 10
