Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558082C1DAA
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 06:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgKXFnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 00:43:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49214 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725616AbgKXFnI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 00:43:08 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AO5Xbd8143005;
        Tue, 24 Nov 2020 00:43:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tiauImaUPmmh16cLi8Ua3hLJWu93NIOiMBaxg/Cbyj8=;
 b=aONTUDvibqKOoYN2qFHit3bOxwckG1UsGrh8W4UU0LdCqi1UjhkFdvBZ1wJXplHLxmZY
 tJpM1lFmI5Xoe9S4krCaYfPBv40fHNMk2jFlHQI6yf39u4nxtuyRTfK7Viq48QJn+aP2
 qyYaiKyH09O5Rf7y3W4cf5T+jNMsvSxY0wAU1cFloksRJuQvsXJTju31A2P6yeC/vxc/
 brvaEtMk3QnTuCl1TSqoU2I7YaWac7oAeugtDL8/XcC6LsrTJgurr7RgWr8a6FZLN4Vo
 ome2xy4M3qcbu+PSyMpb5b9FtqxXId3zLcURlX6ACidoRBEj5eUsJpqxIdYfdqHZTOn0 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350uq2gju3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 00:42:59 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AO5ZKN0151835;
        Tue, 24 Nov 2020 00:42:59 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 350uq2gjtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 00:42:59 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AO5gv1Q023807;
        Tue, 24 Nov 2020 05:42:57 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 34xth8b7km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 05:42:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AO5gtqP9962202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 05:42:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12427A4054;
        Tue, 24 Nov 2020 05:42:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D0E5A4064;
        Tue, 24 Nov 2020 05:42:51 +0000 (GMT)
Received: from [9.160.115.90] (unknown [9.160.115.90])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 05:42:50 +0000 (GMT)
Subject: Re: [PATCH 05/11] exec: add debug version of physical memory read and
 write API
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        mtosatti@redhat.com, ssg.sos.patches@amd.com, armbru@redhat.com,
        qemu-devel@nongnu.org, dgilbert@redhat.com, rth@twiddle.net
References: <cover.1605316268.git.ashish.kalra@amd.com>
 <7f254436d56679b27ba0112c16472831a6a66b49.1605316268.git.ashish.kalra@amd.com>
From:   Dov Murik <dovmurik@linux.vnet.ibm.com>
Message-ID: <84180351-5946-b138-980e-f5192baa6868@linux.vnet.ibm.com>
Date:   Tue, 24 Nov 2020 07:42:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <7f254436d56679b27ba0112c16472831a6a66b49.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_01:2020-11-24,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011240033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16/11/2020 20:51, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Adds the following new APIs
> - cpu_physical_memory_read_debug
> - cpu_physical_memory_write_debug
> - cpu_physical_memory_rw_debug
> - ldl_phys_debug
> - ldq_phys_debug
> 
> The subsequent patch will make use of the API introduced, to ensure
> that the page table walks are handled correctly when debugging an
> SEV guest.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---

[...]


> diff --git a/softmmu/physmem.c b/softmmu/physmem.c
> index 2c08624ca8..6945bd5efe 100644
> --- a/softmmu/physmem.c
> +++ b/softmmu/physmem.c
> @@ -3354,6 +3354,53 @@ inline MemTxResult address_space_write_rom_debug(AddressSpace *as,
>       return MEMTX_OK;
>   }
> 
> +uint32_t ldl_phys_debug(CPUState *cpu, hwaddr addr)
> +{
> +    MemTxAttrs attrs;
> +    int asidx = cpu_asidx_from_attrs(cpu, attrs);
> +    uint32_t val;
> +
> +    /* set debug attrs to indicate memory access is from the debugger */
> +    attrs.debug = 1;
> +
> +    debug_ops->read(cpu->cpu_ases[asidx].as, addr, attrs,
> +                    (void *) &val, 4);
> +
> +    return tswap32(val);
> +}
> +
> +uint64_t ldq_phys_debug(CPUState *cpu, hwaddr addr)
> +{
> +    MemTxAttrs attrs;
> +    int asidx = cpu_asidx_from_attrs(cpu, attrs);
> +    uint64_t val;
> +
> +    /* set debug attrs to indicate memory access is from the debugger */
> +    attrs.debug = 1;
> +
> +    debug_ops->read(cpu->cpu_ases[asidx].as, addr, attrs,
> +                    (void *) &val, 8);
> +    return val;

You probably want tswap64(val) here like in ldl_phys_debug (even though 
I assume it's a noop in the SEV case).

> +}
> +
> +void cpu_physical_memory_rw_debug(hwaddr addr, uint8_t *buf,
> +                                  int len, int is_write)
> +{
> +    MemTxAttrs attrs;
> +
> +    /* set debug attrs to indicate memory access is from the debugger */
> +    attrs.debug = 1;

Maybe:

     MemTxAttrs attrs = { .debug = 1 };

(Also in the functions above.)

> +
> +    if (is_write) {
> +                debug_ops->write(&address_space_memory, addr,
> +                                 attrs, buf, len);
> +        } else {
> +                debug_ops->read(&address_space_memory, addr,
> +                                attrs, buf, len);
> +        }
> +
> +}
> +
>   int64_t address_space_cache_init(MemoryRegionCache *cache,
>                                    AddressSpace *as,
>                                    hwaddr addr,
> 
