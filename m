Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B282A10508F
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKUKcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:32:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57607 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726132AbfKUKcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 05:32:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574332341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OrTHs4p3T+JKjlu+h7xt1dI+m5b6CE2uVtQ3GAVVvOw=;
        b=DUldVnQ2fyObtzlJX2rU5Qrdjeu4H6MarYCbheRtAVVGdTDLHGTEg8DA1oeHfBAt/4d2Kj
        kg9CBvd+Rd1nb97qdudrztkaRSkz/hB0OZEGX+dVYyziSasiGwF2gOoMyWLh0OVb1FxLr7
        VufaH+N9UtMFDGTfhcqge75L0tDwkrw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-ZkfSVSPjN22zsbxp3uquQQ-1; Thu, 21 Nov 2019 05:32:17 -0500
Received: by mail-wm1-f71.google.com with SMTP id z3so1377625wmk.1
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:32:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sEn8j3qljU8xWoRVJTyVCoe4Ukb/pvIY7iS6FUz/GhE=;
        b=TEmP2sOH0lt2h1frhlXHGvr9ZdnuDTk6dDFEJrEUl/5c2HEhZ9/rTSIYlbYXOemasR
         RdzoHl9PNtItedmpOJR+knPk/J0uTBHD+5iiwrA/virZNa4q7tnmT7Xsxi98fQ/jfLgF
         jCzmqCrcNrgkmtrzdbwZEgaJW1cYNXE8EjkB3NubOY9wh6yFDPdwfK9qIuPBVnjx9rqP
         vLEXDno7a89eCSvR27UjKxrGmJgf85gfKgdKyMjdVywrl+ZptHh38fnKfNTrGtxFR7zL
         CIwWQI3faG+W4z4Ici5jMqdkmoxS8S5lti0r9A4akAY4FdNnppbvEjDNutfXz11SltWy
         EiDg==
X-Gm-Message-State: APjAAAWE1iOvrFvA8TdwDmIf8LNODG9yFAnKtfTZ/9bzgyEeIughouFH
        r6xS6q4yXeZov43ovVtW38jGYlg7PcY3XxqC1CciCsu/sw12eaKYF15bWKXRdZLijDm5Al7Uo2w
        kZCdfNQEGpYzR
X-Received: by 2002:adf:c786:: with SMTP id l6mr9233674wrg.45.1574332336463;
        Thu, 21 Nov 2019 02:32:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqwxq5NnzjVp/mYmPkleWYkx2uLA3odk4o+lmaU+fJmK8nj8HEelO6h1h7dbCYbr1aeiS7Tu0g==
X-Received: by 2002:adf:c786:: with SMTP id l6mr9233640wrg.45.1574332336183;
        Thu, 21 Nov 2019 02:32:16 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id w17sm2876245wrt.45.2019.11.21.02.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:32:15 -0800 (PST)
Subject: Re: [PATCH v7 8/9] mmu: spp: Handle SPP protected pages when VM
 memory changes
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-9-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ac9aa811-7a20-8481-7ddc-a2e39899cee1@redhat.com>
Date:   Thu, 21 Nov 2019 11:32:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-9-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: ZkfSVSPjN22zsbxp3uquQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> +=09=09=09/*
> +=09=09=09 * if it's EPT leaf entry and the physical page is
> +=09=09=09 * SPP protected, then re-enable SPP protection for
> +=09=09=09 * the page.
> +=09=09=09 */
> +=09=09=09if (kvm->arch.spp_active &&
> +=09=09=09    level =3D=3D PT_PAGE_TABLE_LEVEL) {
> +=09=09=09=09struct kvm_subpage spp_info =3D {0};
> +=09=09=09=09int i;
> +
> +=09=09=09=09spp_info.base_gfn =3D gfn;
> +=09=09=09=09spp_info.npages =3D 1;
> +=09=09=09=09i =3D kvm_spp_get_permission(kvm, &spp_info);
> +=09=09=09=09if (i =3D=3D 1 &&
> +=09=09=09=09    spp_info.access_map[0] !=3D FULL_SPP_ACCESS)
> +=09=09=09=09=09new_spte |=3D PT_SPP_MASK;
> +=09=09=09}

This can use gfn_to_subpage_wp_info directly (or is_spp_protected if you
prefer).

Paolo

