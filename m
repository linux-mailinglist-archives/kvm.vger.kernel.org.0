Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232421598A6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 19:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgBKSbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 13:31:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41645 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730165AbgBKSbr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Feb 2020 13:31:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581445905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hd8VPzkhK8n9/lwhgrwAyRD2bhnpTGXUCuZRADWF3wk=;
        b=VYtUUgrwOaGygKk20gEBIN9XUFnx4iWU3Pcoygx1J4X7YsaReDQ22f5wuE3vrukY0bxdD6
        o9FUaUJn7TQw5b0mECFhqyvKGhjenAnpy5/Z9L3c/nGT9tZLlYR+z/iTuGJaFDvDyqeL4J
        Z9/v5n0PQKYE7SDF490Ak5Tavb7OwNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-2Smuds_WMvW744S-HoF1CA-1; Tue, 11 Feb 2020 13:31:42 -0500
X-MC-Unique: 2Smuds_WMvW744S-HoF1CA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 142A5477;
        Tue, 11 Feb 2020 18:31:40 +0000 (UTC)
Received: from [10.36.116.37] (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6303960499;
        Tue, 11 Feb 2020 18:31:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/9] arm: pmu: Basic event counter Tests
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Andrew Jones <drjones@redhat.com>, kvm-devel <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger.pro@gmail.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-6-eric.auger@redhat.com>
 <CAFEAcA9Yc9dKTCcP3fP93tQU62Q=2FYOoYGvUqfiOMY=pYV_RA@mail.gmail.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <94fcec29-d44a-98cf-c397-b23b5d355eac@redhat.com>
Date:   Tue, 11 Feb 2020 19:31:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9Yc9dKTCcP3fP93tQU62Q=2FYOoYGvUqfiOMY=pYV_RA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 2/11/20 5:27 PM, Peter Maydell wrote:
> On Thu, 30 Jan 2020 at 11:26, Eric Auger <eric.auger@redhat.com> wrote:
>>
>> Adds the following tests:
>> - event-counter-config: test event counter configuration
>> - basic-event-count:
>>   - programs counters #0 and #1 to count 2 required events
>>   (resp. CPU_CYCLES and INST_RETIRED). Counter #0 is preset
>>   to a value close enough to the 32b
>>   overflow limit so that we check the overflow bit is set
>>   after the execution of the asm loop.
>> - mem-access: counts MEM_ACCESS event on counters #0 and #1
>>   with and without 32-bit overflow.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
>> +static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
>> +{
>> +       int i;
>> +
>> +       if (pmu.nb_implemented_counters < nb_events) {
>> +               report_skip("Skip test as number of counters is too small (%d)",
>> +                           pmu.nb_implemented_counters);
>> +               return false;
>> +       }
>> +
>> +       for (i = 0; i < nb_events; i++) {
>> +               if (!is_event_supported(events[i], false)) {
>> +                       report_skip("Skip test as event %d is not supported",
>> +                                   events[i]);
> 
> Event numbers are given in hex in the Arm ARM and also
> specified in hex in your test source code. I think it
> would be more helpful if the message here used "0x%x", to
> save the reader having to do the decimal-to-hex conversion
> to find the event in the spec or the test case.
Sure I will fix that

Thanks

Eric
> 
> thanks
> -- PMM
> 

