Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC3B1EB3D7
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgFBDjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgFBDjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:39:16 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7771AC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:39:15 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 185so4443979pgb.10
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=25Z4PyvxNXVbTrzp+EyuP3SY+XgzmEQiG1XewmY0Vt0=;
        b=pBbKG4Ned4JGzOS+DVQGLSL5lT8WKb7rLDhvz96CmaBMlRH8kG9MwhSAltMvaTbzVv
         HRUvhXQIqj+AVwyFdX9vq4SezeXTe9RMKkboET2Z8WK44NtEH77TAm19VoMoSpVEgU1Y
         O0RKujZ0XLjJ24xI7+2lD1qpgJLARLqWwCC4SREMvITR9Veyfc0M3/itGIeTZB2kpI4M
         S1tnXfDZ90AqasEYOoFY4UOU+OmfnnUmoya1yVkJlmHt8HFOSGFGB/sfeHULcsWnguQj
         U6ADDxePnL5/aUp2CZzleT0Px+Q6rlb6VVBMbFqzGiW1rXoJ3g3LqQRGU7g+ZqyS1SZ5
         Va1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=25Z4PyvxNXVbTrzp+EyuP3SY+XgzmEQiG1XewmY0Vt0=;
        b=kvEll/RzyFLjCE5FwGaIpaMsHqzyuxWbkgC/IJjQ01Uumran7ONrZpleiy3WEP7KwJ
         I8WzWr/pbKBDBA2ihXdo7DlyxGbQ8h875+MYgQzEJopSBpSnBYWyOT7Sz/UtnHwHUNKF
         YNHi7306iCKwbhEqImIr6nr+piY13KqMaV0UNwurjhrmyXWhYno1gh6m27iseMfnYYAt
         KdUUbUNEP5hHvndzH3DR3x6UwK60ldp9/97Ex1QxBAZagQTiLYJzaqu8HSpUqNj7Z9kk
         OhG4NHPSCQbAdONbOT073cddvESCoHWE0CwTVmWgqIRIGhaUxVJtEvgbDyKNFceEAf5l
         4i1A==
X-Gm-Message-State: AOAM530oIjpC5goRyqMCtgZe6xdv/mprvRKeqii+N2uXLweju/Mdanhv
        lCM7B0M70VJqbhegnj8f6SElVQ==
X-Google-Smtp-Source: ABdhPJxRVnXSi5kwrj1LQ9UbzAVSlZeTuh/DCMjegFU5ZiSSCvExjTP2GfAuGamVgwL1M5vVHOj3/A==
X-Received: by 2002:a63:f959:: with SMTP id q25mr21567037pgk.137.1591069154965;
        Mon, 01 Jun 2020 20:39:14 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id x9sm731014pfi.13.2020.06.01.20.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:39:13 -0700 (PDT)
Subject: Re: [RFC v2 12/18] guest memory protection: Perform KVM init via
 interface
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-13-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <e0b5be25-db1f-ab7d-681b-bd8afdecf4e2@linaro.org>
Date:   Mon, 1 Jun 2020 20:39:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-13-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> +        if (object_dynamic_cast(obj, TYPE_GUEST_MEMORY_PROTECTION)) {
> +            GuestMemoryProtection *gmpo = GUEST_MEMORY_PROTECTION(obj);

This duplicates the interface check.  You should use

  gmpo = (GuestMemoryProtection *)
    object_dynamic_cast(obj, TYPE_GUEST_MEMORY_PROTECTION);
  if (gmpo) {

AFICT.


r~
