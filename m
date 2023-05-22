Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44EFA70C93E
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 21:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbjEVTqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 15:46:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbjEVTqA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 15:46:00 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730ADA9
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 12:45:58 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MJd3pJ025562;
        Mon, 22 May 2023 19:45:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=asFqEK4jS1cxympzwrCDk2p3tKRpiGz4CFdqkh3No54=;
 b=piusIZJmN6S1YpoMgdo/Skxaztz2sONP8dGQN4zslWWYwZj5G1bbdFubcleGtMlWCptF
 s5fP5GJ2SLp5HNEeZWq62sBimRyoMFVe4pcdM8/BKyaSQ1hOXhb2gWCEATD2Kp5QGRWG
 QtusT9rLSzccqVPpNyeWvIKNSlG9YS+Uc1D7U51lI0dbfs5DV2NHRG2W/akMNjSpJlFl
 GGoKu/MMPeFlMq9FjWVotpairMXprrfeSqIKIJpQiRh1xHd938T3hX3WFuvz9IdSvWCI
 B7rlyLvYr8Av+5sAhd+DkoKsPRsWXrowTQ5+C8EBv4klPK8PRHfL+3BQ/FEt/0/l+xSh NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qregs8cv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 19:45:47 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MJfw6I002447;
        Mon, 22 May 2023 19:45:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qregs8cua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 19:45:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34M8tUoP032622;
        Mon, 22 May 2023 19:45:44 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3qppc3h3xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 May 2023 19:45:44 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34MJjdjR45154670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 19:45:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2460720049;
        Mon, 22 May 2023 19:45:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDABE20040;
        Mon, 22 May 2023 19:45:37 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.42.164])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 22 May 2023 19:45:37 +0000 (GMT)
Message-ID: <b695a55e294038b2a9e300031f27a74c36b49b5d.camel@linux.ibm.com>
Subject: Re: [PATCH v20 15/21] tests/avocado: s390x cpu topology polarisation
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Mon, 22 May 2023 21:45:37 +0200
In-Reply-To: <20230425161456.21031-16-pmorel@linux.ibm.com>
References: <20230425161456.21031-1-pmorel@linux.ibm.com>
         <20230425161456.21031-16-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6SWkhdH-QcwS7EiTZQqpnNlqFLMxlQzR
X-Proofpoint-GUID: vFgGmVsO3G4aPhyHxXDIl6cZHW3g8i46
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_14,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 clxscore=1015
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305220165
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Try to be consistent in the spelling of polarization.
You use an s in the title and in the test name below.

On Tue, 2023-04-25 at 18:14 +0200, Pierre Morel wrote:
> Polarization is changed on a request from the guest.
> Let's verify the polarization is accordingly set by QEMU.
>=20
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  tests/avocado/s390_topology.py | 38 ++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>=20
> diff --git a/tests/avocado/s390_topology.py b/tests/avocado/s390_topology=
.py
> index ce119a095e..30d3c0d0cb 100644
> --- a/tests/avocado/s390_topology.py
> +++ b/tests/avocado/s390_topology.py
> @@ -104,6 +104,15 @@ def kernel_init(self):
>                           '-initrd', initrd_path,
>                           '-append', kernel_command_line)
> =20
> +    def system_init(self):
> +        self.log.info("System init")
> +        exec_command(self, 'mount proc -t proc /proc')
> +        time.sleep(0.2)
> +        exec_command(self, 'mount sys -t sysfs /sys')
> +        time.sleep(0.2)
> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
> +
>      def test_single(self):
>          self.kernel_init()
>          self.vm.launch()
> @@ -206,3 +215,32 @@ def test_hotplug_full(self):
>          self.check_topology(3, 1, 1, 1, 'high', False)
>          self.check_topology(4, 1, 1, 1, 'medium', False)
>          self.check_topology(5, 2, 1, 1, 'high', True)
> +
> +    def test_polarisation(self):

I would unite this test with test_query_polarization, they are very similar=
.

> +        """
> +        This test verifies that QEMU modifies the entitlement change aft=
er
> +        several guest polarization change requests.
> +
> +        :avocado: tags=3Darch:s390x
> +        :avocado: tags=3Dmachine:s390-ccw-virtio
> +        """
> +        self.kernel_init()
> +        self.vm.launch()
> +        self.wait_for_console_pattern('no job control')
> +
> +        self.system_init()
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +        exec_command(self, 'echo 1 > /sys/devices/system/cpu/dispatching=
')
> +        time.sleep(0.2)

Can you find a way to wait for the event here?

> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', '1')

I think it would be good to refactor this snippet into a function.

def guest_set_dispatching(self, dispatching):
        exec_command(self, f'echo {dispatching} > /sys/devices/system/cpu/d=
ispatching')
        #TODO wait
        exec_command_and_wait_for_pattern(self,
                '/bin/cat /sys/devices/system/cpu/dispatching', dispatching=
)

or similar, you could also put the path into a variable.

> +
> +        self.check_topology(0, 0, 0, 0, 'medium', False)
> +
> +        exec_command(self, 'echo 0 > /sys/devices/system/cpu/dispatching=
')
> +        time.sleep(0.2)
> +        exec_command_and_wait_for_pattern(self,
> +                '/bin/cat /sys/devices/system/cpu/dispatching', '0')
> +
> +        self.check_topology(0, 0, 0, 0, 'medium', False)

