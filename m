Return-Path: <kvm+bounces-67839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7443BD15811
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 22:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 37F4F3054661
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 21:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2655345CBC;
	Mon, 12 Jan 2026 21:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b="YodaQu6U"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8BC24A05D;
	Mon, 12 Jan 2026 21:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768255129; cv=fail; b=eIPKzYqAE8TML/jdBWrY5UejwZ7rC0c/W9Q0Rjh4TquZGgxPRp44Fh0CvuOgoN7ZQys86HNJGPlGnDaey57GyY3anPB4A9FJb3cAj6tnrZ2cXHgvP7IyFLRoQxLYHXuNNafEQFk/zHhe1Rvfh+T/tBmx++OCRqjxkoY3q00G9rA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768255129; c=relaxed/simple;
	bh=+cG2KV9zORDjdREWs5b4bSZttIdY83RMjSmagyvywGA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CmTjdBJ//uXlcUIEOLEJ9B8FQkiQdllnSuxR6TELmYhK0uHMeN6IXDikvWx8W618KIfIUFS4u3LR5LAORMd93GSGlPmfwwEp8EGVpe3sXT2pWN98XoFzYBmDdaoTYtFLfdjNgwHA14rc/8YttqGAPIr2CGCdBXgtdxfHFiGHSEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com; spf=fail smtp.mailfrom=nokia.com; dkim=pass (2048-bit key) header.d=nokia.com header.i=@nokia.com header.b=YodaQu6U; arc=fail smtp.client-ip=40.93.196.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cYI+KFiDBt//GDpR67XB7W4IUAzI+b8zhxXshfn/30SxetnSQg2X63jAJBleN5QX+F5vH/zcrhhOrHOT8wTUtC1X1grLXevMwtYyseATHP8la6HysHqDZ1H5p2S/ug/O+hmbQxh+S9YgesEK0doxzXWzTyFbcnf+1nWoVbVtJF85D9/ouutruMUucnWksCRoY831R6lAGtQ4PE+VjxxyA3lL4JHMnkcMCfgSHY7vPAd29/2RQZaQknfIAdGatxd+ItdOtN9YUTfNUxKbsDC2OVal5vNRmeXB6db5kJbrBVWnu8e01dLe9ZFWXVdunoFibe6lS/cnX1LLzZdtGjIuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8TEehAGqXpspNmWFZMGN4mOuEOBPfze3uox7rzgsl0=;
 b=RHhnTtjUU4jPkKKVLYx7BI2V4oR7jQUkzllvUDw63fBKiazjDcKMikXkV2inv54uHFLAJGRdEvYMpHMlZMwrrYRdPdiSXId04+5mj/3drT0Fhmwzfr28jftFhJLafy4jpWD4hgw4+E6eLWfjKJ5OirF9itYQw+bh68xQZMR6zClVZ7dYeMez6wNX/xnOZwFweZuV7eF/eg68eyXg9EJRVrvcB4bzKUQL8+lRVk7obKbHYP0GrKTIbypeF/HrIr7p2BrIdTyzZlz+/+HFmwH4LdVuHtE38eTdCfpfe3qCbGFaH38747KXkgVTVU0sFONL7ShN5JcG530vq5zIEpRTvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8TEehAGqXpspNmWFZMGN4mOuEOBPfze3uox7rzgsl0=;
 b=YodaQu6UqZJzZOFY7OwdFs4fhVA9+35E6X6Gx2Ta9tV7SA4pVozT+NbvKn7aqA/9xP8V1bgo7CWYJekkxQi05DIS5vfh3LDQDOvB03q14sRYb9leflTe7XL/Na/+fR/tqBNbCfjQcfWb9UnpbpxmYleAxSUSWAyc0+gXa09WKLR5TWPMw0Sj2misPFnQMaPTrKJ08bD19xA1A6UJ9tJ27TTdnyFb6qsW7ER3PiKZWAtGidw/vIAQIpvmrdwGbCDw5EfHnfxZ7OqH8u9CkvgPHwoXmahEC1vCIwKoTTY1L8niAeCKONpVU+I3G1nBW8lwMzpOwofLcXVu1ajCVqF0qw==
Received: from BN0PR08MB6951.namprd08.prod.outlook.com (2603:10b6:408:128::14)
 by CO1PR08MB6756.namprd08.prod.outlook.com (2603:10b6:303:91::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Mon, 12 Jan
 2026 21:58:44 +0000
Received: from BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178]) by BN0PR08MB6951.namprd08.prod.outlook.com
 ([fe80::4dd1:e1e:56b0:b178%3]) with mapi id 15.20.9520.003; Mon, 12 Jan 2026
 21:58:44 +0000
From: "Anthony Pighin (Nokia)" <anthony.pighin@nokia.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>
Subject: VFIO_GROUP_GET_DEVICE_FD triggering an "unlocked secondary bus reset"
 warning
Thread-Topic: VFIO_GROUP_GET_DEVICE_FD triggering an "unlocked secondary bus
 reset" warning
Thread-Index: AQHchApJwXo7jE/TTU6VWYzwDb4VDg==
Date: Mon, 12 Jan 2026 21:58:44 +0000
Message-ID:
 <BN0PR08MB6951416BAFA500FC9902DAA68381A@BN0PR08MB6951.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR08MB6951:EE_|CO1PR08MB6756:EE_
x-ms-office365-filtering-correlation-id: a1ac7122-2df3-467b-b93a-08de5225c12a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?SQ831sGRtZN9oh8Ror8Up6ABklHAjfB4fyEJAL03bzIRSZ+60grDgYtQqq?=
 =?iso-8859-1?Q?c7RLlJPgGtFoXoPJXsXeTpmwy6yFaG+zK7YnVr+A9xpBSFqoxHVN8f18Ux?=
 =?iso-8859-1?Q?4+ITBM2UT+XkETu8MLrDZVOdBssvoOA0U1zhBzXrnQRCNLdRxrtPIrHNvH?=
 =?iso-8859-1?Q?4Ppd32e1M34BuwnElg5tN/nQw51PhwfSGEniwka8dd9btCuHnzhOj/CcmD?=
 =?iso-8859-1?Q?bwKvutF/UCL5scsoQzYTC6jZ3S3TRdxIeEXe9UWxAi1yLNqSWUvYctwJa8?=
 =?iso-8859-1?Q?DNhrCjM5nSgTZsbyao5ao0kceKvc7Mf3+/BmN8XTJY4VrIVrmYtJSQXUWY?=
 =?iso-8859-1?Q?OvHRuiMIfdyKklpgR9/ltYXXSjDdbP/0P+hl7VaHpdOpd0kmFO3GFS1MRq?=
 =?iso-8859-1?Q?lPRlnObCLk6p1bzet6ZHF8uj+UcN36N+UBpog5qWELgYKMV2KWeV8APGiX?=
 =?iso-8859-1?Q?N9/N2ZSlWdJIKMSXXSB0dc6RDT/sTbwk/9PTyVisOQrcAUj4iXUmSVChBM?=
 =?iso-8859-1?Q?YsG2y70EOahSHScAnJp0NMy+KMUc2IIez0Cpb+8NmFQw+4bxD8m6PSv4to?=
 =?iso-8859-1?Q?twpDXaE3qWLM5Q30zzRMu6fNIPQgD81ung6ujwdcAHnNPQRMC3hQrEwoWV?=
 =?iso-8859-1?Q?3kxNIhkWkRxyVNKGZkVWeD2omPO0uskkGUxgsRUeFm2VxfDkcdXsSmvm3A?=
 =?iso-8859-1?Q?MkqU1mdeHQd1eRxmlceko3xqdpdqS7frpQ87FVp6aC6/Hays9sCKCdb+eQ?=
 =?iso-8859-1?Q?M8ugTeErUBHiNOuVW23iGfyofJb2cJMBxjM1Aui2BjTHb4HKdTAOb1B/JG?=
 =?iso-8859-1?Q?nqdKWUnIl4/Knu850UGcGabvywHc5PvRCELwfi2y1K6DIdxmIXg90ljrle?=
 =?iso-8859-1?Q?fQnBW4yblRs/4w4R00lGcf6rHi8DFIAFWdykyXU11TjiyAg2vsT/8KAZm4?=
 =?iso-8859-1?Q?+DwXUh8JJgrfz7C7oJc9CVtiGxYcz/u4A85HpUWlJFW2WdbOLz3pPO33VT?=
 =?iso-8859-1?Q?UCvv0m9r3QurSW1Dm07FSdciYjjkUxCOivF44FCaFPvWbrwmYMpoU8y5P2?=
 =?iso-8859-1?Q?/mKfik/cKPu/n6hudwT6cMuOw0L0lX8k/48/BJnUWgG2wtrBT+F8sVJBp5?=
 =?iso-8859-1?Q?qL1K3UbyKvklHm50TlL7CmwAPU/L+/51PWepLkBSjxLzjJz/j70s8Aw3Ku?=
 =?iso-8859-1?Q?D8wmPpCnl/yXmXr5QPuMELzTecYVtPGQuvYDA/bZ0G2XkEL2wDQdqGNr0U?=
 =?iso-8859-1?Q?gdfz9RzDE+McNkWEyzqGjWu2dM/omuo5x1JcjuDuJUKTLtVaIb8W0vUM1G?=
 =?iso-8859-1?Q?4qMEaO9UorC6HrF261kIL+plhwb2YKL5YYO/p5kWr+fxpTyiLkptLVI617?=
 =?iso-8859-1?Q?gFmch/NhNvgN81Elbs9RXCjLu3WRvZtj2yp0QGKlY8nXge94Avg1KVYIJN?=
 =?iso-8859-1?Q?2+NUgr5zu2SBCVpm/3f2pE/vbc/BfNV3roF8B21hobWUMgnmPGk0nrQUWw?=
 =?iso-8859-1?Q?MUK35ePLSJSa+Ss7iUbuvEA2CXuRlCabdh2QUyQah388b2L7K4rYBVQMwo?=
 =?iso-8859-1?Q?7wKmHdjEymwWps14JrB+ZeC6VKa5?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR08MB6951.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?YosOiiSF7cROI8THTUufbpUxQtFMAAHowfNNrcj6C/zgyp9ryPDs849ERZ?=
 =?iso-8859-1?Q?AaQO3Zom4Tbv/mE24BuROYfhls0PmO61HFjbOwtp2uH789BRtW/6nExPpu?=
 =?iso-8859-1?Q?Laz9DxJy15z0qFnz1gBft+MT9JWwAZWEmW34m8xomCMnJz/KLuNiquYHAi?=
 =?iso-8859-1?Q?SiEHfVP1ag1dNtGwX41HrEQLcAZj/u7IIUvaNgsR5B+ffuvb2wXjvfv6Vv?=
 =?iso-8859-1?Q?I335OOJQVNq1kBnvCmjVu8K3203WRtkKI4D91wrr6FZo9hsPiWrKwG5FYY?=
 =?iso-8859-1?Q?rngEwclED1gTEGsZgU7lEj+r5B6V3AgvNMHG6CLyCSV0nFzJp2ZyuQudra?=
 =?iso-8859-1?Q?p1priz2lxjNdd5zOjPlOcKySM3kq77HR9XQ7SdzV9OFSCJ8cvTqCrK3Qp7?=
 =?iso-8859-1?Q?ema9OaTi2teO2zzM1/+pqbUdNJjLrgRnW5fkXP3eDv9E3dFNlLr7D1ZrYy?=
 =?iso-8859-1?Q?5mwLvBc3oVx+0bjp3f+tKyLSTpnXgUAbN4kSAtelg17+40uVtt6Ed09aJu?=
 =?iso-8859-1?Q?eEoyl6himudOs675E3gkpV93pH5/AOM3gxAEkdoJU1cNm43B94Mn9PVJGW?=
 =?iso-8859-1?Q?lWz5O5+FeNeVsi3uzpTP35+ULT9BlFu3aObZvG0I8Q6daVjUscdkGAmV/V?=
 =?iso-8859-1?Q?+zHUGTEIYz+/7wxxTvaOmIFpo0La20DBtpetfQqObY2hCH2f5sUwSCAOfj?=
 =?iso-8859-1?Q?nKTNmCdAwNwRYhFnTonR+X4WamK3JsoIkbzSyGsra2pAv8XKTQM+j8e7wn?=
 =?iso-8859-1?Q?NwjjfUT0Z/h3xRebNyCUt4XL2HdcuXxmFa/I0rTpRzIvSiNzqegPNiPl0b?=
 =?iso-8859-1?Q?zqTPB7U7St1qJP/VpvKoZ4YoH/n7g4Dw1pmgrVFCW+Kwb2HyYjfTjOUZjZ?=
 =?iso-8859-1?Q?lvjNPeympoP56QATtSGE3PK0+HphXj7ESJ6oDx0DHLgmzi9e3ZGW9gxWeo?=
 =?iso-8859-1?Q?5ngBdGzpgPjD3HdktOBwT2GOYb1ctVqVaZbC9/Pk0tJMyi6OrdHT8+Umol?=
 =?iso-8859-1?Q?Z5YlTh2EPdpaky7trYMIVUDlpJVYXLA1hXo9WQihw2ht1bolYmnGiNCy++?=
 =?iso-8859-1?Q?V5rXUQgpkgMLfDxiNovTC55JSr2Si4xZEwOlSEtZ0gXtPOcGqqV4xuMsVp?=
 =?iso-8859-1?Q?IqADaYyOCzOG3Fw5hCUqrdv5Sd+6O1p027APJRsx8d6lIOaUlfhV1mWxCD?=
 =?iso-8859-1?Q?8IwJJ9iBZhZ7UlwTbV+Ub4o/T3BewOhK9bqLhUOsnTN4KujacahT+5esF1?=
 =?iso-8859-1?Q?/Y3NgaoK40vMiEp7OBIMxKu1okjj9XJDxI225axIFp4ffC70MlWnzdmYax?=
 =?iso-8859-1?Q?eTdyzJIc/gxwLDlkB7SxO/uzFr85OeoVGb3eFHwxRAQe+H8LlRkdQjuYtf?=
 =?iso-8859-1?Q?Ziop8+C6qBDQ5W2SAYPLiOrbayKd5FX6TzlIqB7mad6d7ucahDaVVyLXRd?=
 =?iso-8859-1?Q?oBiGX+xwzFdaG2twzXrrv7YmCYRt1fr9o4265thdxlY/8xI6/mp2VjuqA7?=
 =?iso-8859-1?Q?jG7I/86tSL/S+u44uPWtkk1YSF/j052RlBBEIwYFPvKY4ugWzcnFYdnbNI?=
 =?iso-8859-1?Q?NXmd5T+SYmsRWruidzfg8OJm+yB4DgX+tse0Vw/abxR1BDcp9Bx5TQM49k?=
 =?iso-8859-1?Q?zuC6Djf/jZXgEC0JDtSiXW6vF1tZWnWmXBAR1LTwlPrTUrVJFI2hxkhU2B?=
 =?iso-8859-1?Q?v8o8yw37s4AF0pZLM113nHyVVUPFlhCwPlhHfQRs/nJdQncz1tu+TAYas4?=
 =?iso-8859-1?Q?WiSJvSF/qZHBRgm88xPoz5/nXzcl6BnXixgPj9gkA1/0SJspXxNB3wgoGd?=
 =?iso-8859-1?Q?X7ZD7qCoAA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR08MB6951.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ac7122-2df3-467b-b93a-08de5225c12a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 21:58:44.1225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZNy+SeDmgiRFhnSrB5/DTqsEortHYDM2OYZe4I6mkUe5dKrEhHLz24AUvCyWirosSkrxP+eajKKI30z7M1TZZ9I8bCoB92RRy9TD7hy37P0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR08MB6756

When adding a PCI device to a VFIO group, the following is triggered:=0A=
pcieport 0000:00:00.0: unlocked secondary bus reset via: pci_reset_bus_func=
tion+0x188/0x1b8 =0A=
=0A=
As a result of:=0A=
920f6468924f ("PCI: Warn on missing cfg_access_lock during secondary bus re=
set")=0A=
=0A=
PCI topology is very simple:=0A=
# lspci -vvvtn=0A=
-[0000:00]---00.0-[01-ff]----00.0  10ee:7011=0A=
=0A=
Full backtrace is as follows:=0A=
[  125.942637] Hardware name: Freescale ARMv8 based Layerscape SoC family=
=0A=
[  125.942642] Call trace:=0A=
[  125.942648]  dump_backtrace from show_stack+0x20/0x24=0A=
[  125.942669]  r7:600f0013 r6:600f0013 r5:c11bd5e8 r4:00000000=0A=
[  125.942672]  show_stack from dump_stack_lvl+0x58/0x6c=0A=
[  125.942688]  dump_stack_lvl from dump_stack+0x18/0x1c=0A=
[  125.942706]  r7:c3663483 r6:c1c2e000 r5:00000000 r4:c1c2e000=0A=
[  125.942709]  dump_stack from pci_bridge_secondary_bus_reset+0x74/0x78=0A=
[  125.942724]  pci_bridge_secondary_bus_reset from pci_reset_bus_function+=
0x188/0x1b8=0A=
[  125.942740]  r5:00000000 r4:c3663000=0A=
[  125.942742]  pci_reset_bus_function from __pci_reset_function_locked+0x4=
c/0x6c=0A=
[  125.942761]  r6:c104aa58 r5:c3663000 r4:c366347c=0A=
[  125.942764]  __pci_reset_function_locked from pci_try_reset_function+0x6=
4/0xd4=0A=
[  125.942782]  r7:c24b3700 r6:c36630cc r5:c3648400 r4:c3663000=0A=
[  125.942784]  pci_try_reset_function from vfio_pci_core_enable+0x74/0x29c=
=0A=
[  125.942802]  r7:c24b3700 r6:c3663000 r5:c3648400 r4:00000000=0A=
[  125.942805]  vfio_pci_core_enable from vfio_pci_open_device+0x1c/0x34=0A=
[  125.942825]  r7:c24b3700 r6:c3648400 r5:c3648400 r4:c3648400=0A=
[  125.942828]  vfio_pci_open_device from vfio_df_open+0xc8/0xe4=0A=
[  125.942844]  r5:00000000 r4:c3648400=0A=
[  125.942847]  vfio_df_open from vfio_group_fops_unl_ioctl+0x3dc/0x704=0A=
[  125.942861]  r7:c24b3700 r6:00000013 r5:c3179cc0 r4:c3648400=0A=
[  125.942863]  vfio_group_fops_unl_ioctl from sys_ioctl+0x2d4/0xc80=0A=
[  125.942879]  r10:c24b3700 r9:00000012 r8:c3757300 r7:beb3c8e8 r6:00003b6=
a r5:c3757301=0A=
[  125.942883]  r4:00003b6a=0A=
[  125.942886]  sys_ioctl from ret_fast_syscall+0x0/0x5c=0A=
=0A=
Some added debug shows that the trylock is successful for the device being =
attached. However,=0A=
the parent (controller) is not locked, leading to the warning.=0A=
=0A=
[  126.254846] pci_cfg_access_trylock: locked for 0000:01:00.0=0A=
[  126.255081] pci_parent_bus_reset called for dev 0000:01:00.0=0A=
[  126.255086] pci_parent_bus_reset: checking conditions for dev 0000:01:00=
.0=0A=
[  126.255091]   pci_is_root_bus: 0=0A=
[  126.255096]   subordinate: 00000000=0A=
[  126.255102]   bus->self: e8833d2c=0A=
[  126.255108]   PCI_DEV_FLAGS_NO_BUS_RESET: 0=0A=
[  126.255112] pci_parent_bus_reset: resetting bus for dev 0000:00:00.0=0A=
[  126.255120] pcieport 0000:00:00.0: unlocked secondary bus reset via: pci=
_reset_bus_function+0x21c/0x220=0A=
=0A=
The reset methods are as follows:=0A=
# cat /sys/devices/platform/soc/3500000.pcie/pci0000:00/0000:00:00.0/reset_=
method=0A=
pm=0A=
# cat /sys/devices/platform/soc/3500000.pcie/pci0000:00/0000:00:00.0/0000:0=
1:00.0/reset_method=0A=
bus=0A=
=0A=
Anthony=0A=

