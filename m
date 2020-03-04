Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5751797B7
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 19:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgCDSVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 13:21:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21229 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729702AbgCDSVh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Mar 2020 13:21:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583346095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nNKk6V4UafjEY7RM/4q9Bsej2pxdLWtMJlUp2kDxLcg=;
        b=VldsUC96Zlns0GzM/rD++dy72oNlfU+O/J/PTSdGPtFM/UgJW5wnOK4EhqxLAu23LPpFyL
        c2J+yC1GIE07Z0SLNE14m7FUG+Z1nUSNBAUJNfM3SGDzb3c8Vs+rYDAvRCOMAbb9T/GS0g
        BHnbHHipaIkKpUlPysdniIBeJYmIdBI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-jSpBxr19NSqeuK5EvpGR7Q-1; Wed, 04 Mar 2020 13:21:32 -0500
X-MC-Unique: jSpBxr19NSqeuK5EvpGR7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EF38100550E;
        Wed,  4 Mar 2020 18:21:30 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3D158B777;
        Wed,  4 Mar 2020 18:21:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/9] arm: pmu: Add a pmu struct
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andrew.murray@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-4-eric.auger@redhat.com>
 <20200304180158.4d9e3b8c@donnerap.cambridge.arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c11424a4-22cc-3ca2-0949-f39c0c4c8b6b@redhat.com>
Date:   Wed, 4 Mar 2020 19:21:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304180158.4d9e3b8c@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 3/4/20 7:02 PM, Andre Przywara wrote:
> On Thu, 30 Jan 2020 12:25:04 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
> 
>> This struct aims at storing information potentially used by
>> all tests such as the pmu version, the read-only part of the
>> PMCR, the number of implemented event counters, ...
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> As I stated already in v1:
Hum that's an oversight. Please forgive for the 2 R-b's I have forgotten.

Thanks

Eric
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>


> 
> Cheers,
> Andre
> 
>> ---
>>  arm/pmu.c | 30 +++++++++++++++++++++++++-----
>>  1 file changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index e5e012d..d24857e 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -33,7 +33,14 @@
>>  
>>  #define NR_SAMPLES 10
>>  
>> -static unsigned int pmu_version;
>> +struct pmu {
>> +	unsigned int version;
>> +	unsigned int nb_implemented_counters;
>> +	uint32_t pmcr_ro;
>> +};
>> +
>> +static struct pmu pmu;
>> +
>>  #if defined(__arm__)
>>  #define ID_DFR0_PERFMON_SHIFT 24
>>  #define ID_DFR0_PERFMON_MASK  0xf
>> @@ -265,7 +272,7 @@ static bool check_cpi(int cpi)
>>  static void pmccntr64_test(void)
>>  {
>>  #ifdef __arm__
>> -	if (pmu_version == 0x3) {
>> +	if (pmu.version == 0x3) {
>>  		if (ERRATA(9e3f7a296940)) {
>>  			write_sysreg(0xdead, PMCCNTR64);
>>  			report(read_sysreg(PMCCNTR64) == 0xdead, "pmccntr64");
>> @@ -278,9 +285,22 @@ static void pmccntr64_test(void)
>>  /* Return FALSE if no PMU found, otherwise return TRUE */
>>  static bool pmu_probe(void)
>>  {
>> -	pmu_version = get_pmu_version();
>> -	report_info("PMU version: %d", pmu_version);
>> -	return pmu_version != 0 && pmu_version != 0xf;
>> +	uint32_t pmcr;
>> +
>> +	pmu.version = get_pmu_version();
>> +	report_info("PMU version: %d", pmu.version);
>> +
>> +	if (pmu.version == 0 || pmu.version == 0xF)
>> +		return false;
>> +
>> +	pmcr = get_pmcr();
>> +	pmu.pmcr_ro = pmcr & 0xFFFFFF80;
>> +	pmu.nb_implemented_counters =
>> +		(pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK;
>> +	report_info("Implements %d event counters",
>> +		    pmu.nb_implemented_counters);
>> +
>> +	return true;
>>  }
>>  
>>  int main(int argc, char *argv[])
> 

