Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B297D11FC
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 16:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377625AbjJTO6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 10:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377598AbjJTO6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 10:58:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D900FA;
        Fri, 20 Oct 2023 07:58:19 -0700 (PDT)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KEvF9J009684;
        Fri, 20 Oct 2023 14:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=vNsYpQ1MlSRZMBq1tUyFyNxlJW06ZuD9pyp0QbfW2cU=;
 b=QgGjO+HKRRGVGzpRo8Ji0tJ5ft1TbpB9/ZIkugVYGMhEui8zhThxxKBg/+R1r0DR1yRI
 tJNCJJ1n/UAtOF7cRauJ8c1QqwSu70ewSxOZUlEIP1xtXP50KF5f0Ksguim1ZGX+SfKH
 erQaxv8EU1MjAsN1AgKiTbqSfc+fXSK949saOr1CRkIdGvmrT7iiityHc8TSidkcO1J+
 sW0XfdIpB3Vcuq9mwCmjGSua1dJQjsLO9JwUG8ZVU8O7A/jRPLWKEvcksPxlK28dNsRZ
 VXeDvUaNKU+0svqdyl2T9Nv0tGAn3RizOZ5UVCWJzKjcNdOPciDgkE+Ekm4xNP5eFYCD pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuus0g002-67
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:58:08 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39KElp9F007439;
        Fri, 20 Oct 2023 14:50:00 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tuum787st-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:59 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39KC4FkE024183;
        Fri, 20 Oct 2023 14:49:07 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tuc295745-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Oct 2023 14:49:06 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39KEn3Mr12845632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 14:49:03 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B95632004B;
        Fri, 20 Oct 2023 14:49:03 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 767A820040;
        Fri, 20 Oct 2023 14:49:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 20 Oct 2023 14:49:03 +0000 (GMT)
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Sean Christopherson <seanjc@google.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 00/10] s390x: topology: Fixes and extension
Date:   Fri, 20 Oct 2023 16:48:50 +0200
Message-Id: <20231020144900.2213398-1-nsg@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Tiyz-BcizCQEFDj7SA7NrW7r3Jbpwi1V
X-Proofpoint-ORIG-GUID: LukZpTHNpcCJcwfUZsMbfS4Z-6v3wh9I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310200124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
 * patch 1, introducing enums (Janosch)
 * add comment explaining 8 alignment of stsi block length
 * unsigned cpu_in_masks, iteration (Nico)
 * fix copy paste error when checking ordering (thanks Nina)
 * don't escape newline when \\ at end of line in multiline string
 * change commit messages (thanks Janosch, thanks Nico)
 * pick up tags (thanks Janosch, thanks Nico)

Fix a number of issues as well as rewrite and extend the topology list
checking.
Add a test case with a complex topology configuration.
In order to keep the unittests.cfg file readable, implement multiline
strings for extra_params.

Nina Schoetterl-Glausch (10):
  s390x: topology: Introduce enums for polarization & cpu type
  s390x: topology: Fix report message
  s390x: topology: Use function parameter in stsi_get_sysib
  s390x: topology: Fix parsing loop
  s390x: topology: Make some report messages unique
  s390x: topology: Refine stsi header test
  s390x: topology: Rename topology_core to topology_cpu
  s390x: topology: Rewrite topology list test
  scripts: Implement multiline strings for extra_params
  s390x: topology: Add complex topology test

 scripts/common.bash  |  16 +++
 scripts/runtime.bash |   4 +-
 lib/s390x/stsi.h     |  47 ++++++---
 s390x/topology.c     | 231 ++++++++++++++++++++++++++-----------------
 s390x/unittests.cfg  | 133 +++++++++++++++++++++++++
 5 files changed, 322 insertions(+), 109 deletions(-)

Range-diff:
 -:  -------- >  1:  334fec11 s390x: topology: Introduce enums for polarization & cpu type
 1:  a5d45194 !  2:  e3fabae5 s390x: topology: Fix report message
    @@ Commit message
     
         A polarization value of 0 means horizontal polarization.
     
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
     @@ s390x/topology.c: static uint8_t *check_tle(void *tc)
    - 	if (!cpus->d)
    - 		report_skip("Not dedicated");
      	else
    --		report(cpus->pp == 3 || cpus->pp == 0, "Dedicated CPUs are either vertically polarized or have high entitlement");
    -+		report(cpus->pp == 3 || cpus->pp == 0, "Dedicated CPUs are either horizontally polarized or have high entitlement");
    + 		report(cpus->pp == POLARIZATION_VERTICAL_HIGH ||
    + 		       cpus->pp == POLARIZATION_HORIZONTAL,
    +-		       "Dedicated CPUs are either vertically polarized or have high entitlement");
    ++		       "Dedicated CPUs are either horizontally polarized or have high entitlement");
      
      	return tc + sizeof(*cpus);
      }
 2:  218cf7c1 !  3:  95c652d4 s390x: topology: Use parameter in stsi_get_sysib
    @@ Metadata
     Author: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## Commit message ##
    -    s390x: topology: Use parameter in stsi_get_sysib
    +    s390x: topology: Use function parameter in stsi_get_sysib
     
    -    Instead of accessing global pagebuf.
    +    Actually use the function parameter we're give instead of a hardcoded
    +    access to the static variable pagebuf.
     
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
 3:  c9723868 !  4:  4b6cf1ea s390x: topology: Fix parsing loop
    @@ Commit message
     
         Without a comparison the loop is infinite.
     
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
 4:  8813e81d !  5:  fc10ff22 s390x: topology: Don't use non unique message
    @@ Metadata
     Author: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## Commit message ##
    -    s390x: topology: Don't use non unique message
    +    s390x: topology: Make some report messages unique
     
         When we test something, i.e. do a report() we want unique messages,
         otherwise, from the test output, it will appear as if the same test was
    @@ Commit message
         into asserts.
         Refine the report message for others.
     
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
 5:  71b82851 !  6:  37ef7a6c s390x: topology: Refine stsi header test
    @@ Commit message
         Add checks for length field.
         Also minor refactor.
     
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## s390x/topology.c ##
    @@ s390x/topology.c: static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
     -	report_prefix_push("MAG");
     +	report_prefix_push("Header");
      
    ++	/* Header is 16 bytes, each TLE 8 or 16, therefore alignment must be 8 at least */
     +	report(IS_ALIGNED(info->length, 8), "Length %d multiple of 8", info->length);
     +	report(info->length < PAGE_SIZE, "Length %d in bounds", info->length);
     +	report(sel2 == info->mnest, "Valid mnest");
 6:  db844035 !  7:  3247ed4d s390x: topology: Rename topology_core to topology_cpu
    @@ Commit message
     
         This is more in line with the nomenclature in the PoP.
     
    +    Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
    +    Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     
      ## lib/s390x/stsi.h ##
 7:  da81fd0c !  8:  0fea753f s390x: topology: Rewrite topology list test
    @@ lib/s390x/stsi.h: struct sysinfo_3_2_2 {
     +	};
      };
      
    + enum topology_polarization {
    +@@ lib/s390x/stsi.h: enum cpu_type {
    + };
    + 
      #define CONTAINER_TLE_RES_BITS 0x00ffffffffffff00UL
     -struct topology_container {
     -	uint8_t nl;
    @@ s390x/topology.c: done:
     -	report(!(*(uint64_t *)tc & CPUS_TLE_RES_BITS), "reserved bits %016lx",
     -	       *(uint64_t *)tc & CPUS_TLE_RES_BITS);
     -
    --	report(cpus->type == 0x03, "type IFL");
    +-	report(cpus->type == CPU_TYPE_IFL, "type IFL");
     -
     -	report_info("origin: %d", cpus->origin);
     -	report_info("mask: %016lx", cpus->mask);
    @@ s390x/topology.c: done:
     -	if (!cpus->d)
     -		report_skip("Not dedicated");
     -	else
    --		report(cpus->pp == 3 || cpus->pp == 0, "Dedicated CPUs are either horizontally polarized or have high entitlement");
    +-		report(cpus->pp == POLARIZATION_VERTICAL_HIGH ||
    +-		       cpus->pp == POLARIZATION_HORIZONTAL,
    +-		       "Dedicated CPUs are either horizontally polarized or have high entitlement");
     -
     -	return tc + sizeof(*cpus);
     -}
    @@ s390x/topology.c: static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel
     +	report(!(cpu->raw[0] & CPUS_TLE_RES_BITS), "reserved bits %016lx",
     +	       cpu->raw[0] & CPUS_TLE_RES_BITS);
     +
    -+	report(cpu->type == 0x03, "type IFL");
    ++	report(cpu->type == CPU_TYPE_IFL, "type IFL");
     +
     +	if (cpu->d)
    -+		report(cpu->pp == 3 || cpu->pp == 0,
    ++		report(cpu->pp == POLARIZATION_VERTICAL_HIGH ||
    ++		       cpu->pp == POLARIZATION_HORIZONTAL,
     +		       "Dedicated CPUs are either horizontally polarized or have high entitlement");
     +	else
     +		report_skip("Not dedicated");
    @@ s390x/topology.c: static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel
     +static union topology_container *check_child_cpus(struct sysinfo_15_1_x *info,
     +						  union topology_container *cont,
     +						  union topology_cpu *child,
    -+						  int *cpus_in_masks)
    ++						  unsigned int *cpus_in_masks)
     +{
     +	void *last = ((void *)info) + info->length;
     +	union topology_cpu *prev_cpu = NULL;
    -+	int cpus = 0;
    ++	unsigned int cpus = 0;
    ++	int i;
     +
    -+	for (; (void *)child < last && child->nl == 0; child++) {
    -+		cpus += check_cpu(child, cont);
    ++	for (i = 0; (void *)&child[i] < last && child[i].nl == 0; i++) {
    ++		cpus += check_cpu(&child[i], cont);
     +		if (prev_cpu) {
    -+			report(prev_cpu->type <= child->type, "Correct ordering wrt type");
    -+			if (prev_cpu->type < child->type)
    ++			report(prev_cpu->type <= child[i].type, "Correct ordering wrt type");
    ++			if (prev_cpu->type < child[i].type)
     +				continue;
    -+			report(prev_cpu->pp >= child->pp, "Correct ordering wrt polarization");
    -+			if (prev_cpu->type > child->type)
    ++			report(prev_cpu->pp >= child[i].pp, "Correct ordering wrt polarization");
    ++			if (prev_cpu->pp > child[i].pp)
     +				continue;
    -+			report(prev_cpu->d || !child->d, "Correct ordering wrt dedication");
    -+			if (prev_cpu->d && !child->d)
    ++			report(prev_cpu->d || !child[i].d, "Correct ordering wrt dedication");
    ++			if (prev_cpu->d && !child[i].d)
     +				continue;
    -+			report(prev_cpu->origin <= child->origin, "Correct ordering wrt origin");
    ++			report(prev_cpu->origin <= child[i].origin, "Correct ordering wrt origin");
     +		}
    -+		prev_cpu = child;
    ++		prev_cpu = &child[i];
     +	}
     +	report(cpus <= expected_topo_lvl[0], "%d children <= max of %d",
     +	       cpus, expected_topo_lvl[0]);
     +	*cpus_in_masks += cpus;
     +
    -+	return (union topology_container *)child;
    ++	return (union topology_container *)&child[i];
     +}
     +
     +static union topology_container *check_container(struct sysinfo_15_1_x *info,
     +						 union topology_container *cont,
     +						 union topology_entry *child,
    -+						 int *cpus_in_masks);
    ++						 unsigned int *cpus_in_masks);
     +
     +static union topology_container *check_child_containers(struct sysinfo_15_1_x *info,
     +							union topology_container *cont,
     +							union topology_container *child,
    -+							int *cpus_in_masks)
    ++							unsigned int *cpus_in_masks)
     +{
     +	void *last = ((void *)info) + info->length;
     +	union topology_container *entry;
    @@ s390x/topology.c: static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel
     +static union topology_container *check_container(struct sysinfo_15_1_x *info,
     +						 union topology_container *cont,
     +						 union topology_entry *child,
    -+						 int *cpus_in_masks)
    ++						 unsigned int *cpus_in_masks)
     +{
     +	union topology_container *entry;
     +
    @@ s390x/topology.c: static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel
     +static void check_topology_list(struct sysinfo_15_1_x *info, int sel2)
     +{
     +	union topology_container dummy = { .nl = sel2, .id = 0 };
    -+	int cpus_in_masks = 0;
    ++	unsigned int cpus_in_masks = 0;
     +
     +	report_prefix_push("TLE");
     +
 8:  5ff58671 !  9:  6ef31e52 scripts: Implement multiline strings for extra_params
    @@ scripts/common.bash: function for_each_unittest()
     +		elif [[ $line =~ ^extra_params\ *=\ *'"""'(.*)$ ]]; then
     +			opts=${BASH_REMATCH[1]}$'\n'
     +			while read -r -u $fd; do
    -+				opts=${opts%\\$'\n'}
    ++				#escape backslash newline, but not double backslash
    ++				if [[ $opts =~ [^\\]*(\\*)$'\n'$ ]]; then
    ++					if (( ${#BASH_REMATCH[1]} % 2 == 1 )); then
    ++						opts=${opts%\\$'\n'}
    ++					fi
    ++				fi
     +				if [[ "$REPLY" =~ ^(.*)'"""'[:blank:]*$ ]]; then
     +					opts+=${BASH_REMATCH[1]}
     +					break
 9:  185e2752 ! 10:  7e5a9bb5 s390x: topology: Add complex topology test
    @@ Commit message
         s390x: topology: Add complex topology test
     
         Run the topology test case with a complex topology configuration.
    +    Randomly generated with:
    +    python -c 'import random
    +    ds=bs=ss=2
    +    cs=16
    +    cids=list(range(1,ds*bs*ss*cs))
    +    random.shuffle(cids)
    +    i = 0
    +    for d in range(ds):
    +        for b in range(bs):
    +            for s in range(ss):
    +                for c in range(cs):
    +                    if (d,b,s,c) != (0,0,0,0):
    +                        ded=["false","true"][random.randrange(0,2)]
    +                        ent="high" if ded == "true" else ["low", "medium", "high"][random.randrange(0,3)]
    +                        print(f"-device max-s390x-cpu,core-id={cids[i]},drawer-id={d},book-id={b},socket-id={s},entitlement={ent},dedicated={ded}")
    +                        i+=1'
     
         Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
     

base-commit: bfe5d7d0e14c8199d134df84d6ae8487a9772c48
-- 
2.41.0

