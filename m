Return-Path: <kvm+bounces-12870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CB688E9D9
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:51:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 919FDB2A8DE
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 14:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C215813049A;
	Wed, 27 Mar 2024 13:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="ZsXwuZKG"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2115.outbound.protection.outlook.com [40.107.127.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D8D15B57F
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711547222; cv=fail; b=jDV9HPzYcGrgTBaWvXNxgQ/1hs2Q0ySAi2f/milB2ol5YOEvaHcslQEp4fpiUXVXGOH2rAibkI4VuANGINjtO4lwQLKPMtklsABzGlDcDwWjNpEy7CN8qrLu9cXWI8iYkvrdRVYQ3L1FLFuU1fe9iKVEIegRFDB+Ovcri/Y+vKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711547222; c=relaxed/simple;
	bh=WUF/fOCaaPbXGaantECNi7SwuqcyXleMhjqAWhGn/sE=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=O/RJOjGqEnQjCdPuo4+YPv72P0xRqU0NH0Xfkcjti6GVJXS8ta2UzrR3iJyomGqsP2b4Gt1LXnUKWiCfRJYLd3SA0lOsRSMJJ38OqnCIS8OcKd5qPta+GCNRRple5JpXL0dd8xlseN9UQXoyn1/5qz8Leb2YktzbTPBBdg0ELKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=ZsXwuZKG; arc=fail smtp.client-ip=40.107.127.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oX0OV7tXwGvwY7LY2u0ONLvmRjZotTTIq39SKuWMXzPS8NXOIpctJ43ZLNB9S6oUj+R4lPaK1bl8pdsn69u2rVl64rfbwa3AwPTqz9OZpGC1QJ1dghjgGk4fxEuBT8UkWAbgWLUUgPqmq48x4Psoktu5XfXhDy7FV/THeWhu7C6Hyx7q0XOR6hz1cAmErKrkb1PakHfBSRHm5dtZ7mCYm/TI0Ehb6yxKJXko8i/xGB7AK9PlS9JNf1XiMp5LdH0GJPC2T6IF9/B+lJVHSok0i9Q7X0T5mYG1suekuYGtNQJ+6NEBnT1Tw3LySDWXPPkd0CyRb1KjAm/YPE3ec5Lk2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUF/fOCaaPbXGaantECNi7SwuqcyXleMhjqAWhGn/sE=;
 b=LreM4mmCbhRw9tFuIIgGgJhuZBqmcdT4fb8mPvkrQSvLkJiAMz6YUjEBE79V1MqZ40ufB0YWbc9c0hhlzEpme6M7DJJNEsiWIcFdpAphNPDa3CtLTXhpvQXXLq5pnYB/WrOWwmZxJeX+bFnJ8Pw+u6/uignJjjS807/YzNIoOrQ/bHIsCwGIvwDhK6sDgCEh9Au6zw3n8Y38b0LveurVL+4Sl9W00YyhbOvDQfEqv2mS96iwgI1TCOLe78MAXqW3Zm1xQQcyJfPyMGDLSwdfieDv3DOp8KamMa5f89dVFg2iDn6blvi/xqj3FzSTeP/XZKDMXQVoKxrAhacBtHU3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUF/fOCaaPbXGaantECNi7SwuqcyXleMhjqAWhGn/sE=;
 b=ZsXwuZKGraTARllt7OYQ4sIXshwBBk0LkfeadyERbG9Y5M8G2vPeYPOaXNJ16mGA5lEj3odoxNyA4rQ5UAIgK6v7xRiJA3+ln7QROoVUwd8yEKC7ufTdnVBaN3Bfvv7+7jxpnq1E8+Z54ADuTFEIRCH7SEfGuiVLBpsr5JPoB5pC1FA1/xJXM6pMGvv+m6oMDFFdfpgK79/My/pmnWOpbulBQju1GdNkaC51VLo9ZQ6sxsJzT6iIbC61r5/7XI8/3K35/ZlO/DqPI09SnKiFo4NH97eO0CiKfwDZzL12j8TO9LA8Azwpr22WMtQf7Un9LZP+spGZhqa6n1nO037r0w==
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 BEUP281MB3701.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:9f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.32; Wed, 27 Mar 2024 13:46:53 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::81ea:6c20:c76a:b7ad]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::81ea:6c20:c76a:b7ad%7]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 13:46:53 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Subject: Timer Signals vs KVM
Thread-Topic: Timer Signals vs KVM
Thread-Index: AQHagE068r/MPqfdwUiSZ7JW+AmgHQ==
Date: Wed, 27 Mar 2024 13:46:53 +0000
Message-ID:
 <acb3fe5acbfe3e126fba5ce16b708e0ea1a9adc9.camel@cyberus-technology.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR2P281MB2329:EE_|BEUP281MB3701:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 iU9RhuMLw6scphD5PlEVKFomMLNfZSfNR6qBnagGQEhGc2mldl32tFWz/fz9vkfY2rXDeWp6if6VWvBI9UH16OuWFRlozojRkOu/80drlcnu7wEpKHPjgyC8CME+U9D2MmiSip2X93VI8lP9wb9mizS3DtZU8jQa24+UkINyhVOvfCcNGjwZdi7TM9NjUVp5DloqXhyrwSWQLmqNvWUhWdzyKQ88kkZOo4pXa1Abr0l36KIQllchKcXFS/sA/ZWmKzoB8jIh8zkN5itIN7dncexGcx9prXYxb/P/1EJ5dKBYm6MC7NHjlEGmIzwtTeiDZBGp4ibN+TqZ1wd+3N19G8+/rdYREqpUBkM0kxUh2OG7kCQFjK8Zb5clcOtnZu7Ya4wG3urQ2sOwXZv+NzA5hRw5ZOp0Bn7yMOFq3dONoHtQD23tYJESOqWgCHxVJpdJm+tmaWHcD8+timPIQSLphUKa9GyqHIAdnnEaYnEgjEJUttEO4ZH+prDmn/i5hkACXh9urmJREDYo7OqZbYKr02QJFwVHqXRsbndHVIAq8vVRGOHZkpXAmtMIpbfQP4OWdUDYdDsBiRdTFcNjykce36AOIKODfJjoFuftydBV6BM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TlFvKzhzbnA4WTJhcnZtaTRSWm5QUE5LM1Y2TjVFZGphQ3QweEJlS2xxSWta?=
 =?utf-8?B?YkJ0c2pUUzlnck52OUI2dGZUUUg4NW80SGR5dk91Yi9xK0tEMStkcDk4dndQ?=
 =?utf-8?B?QWhtOHdYS3FHc0VuYVhSallQb3dKdzFETktoMi9idXBUTC9PTThldlBCNWox?=
 =?utf-8?B?NkZKUGZJaHk2bWhmK290Y3g4NmU0bjh5Qkh4NXh4Vmk4SHNUaU16YlIvWmM0?=
 =?utf-8?B?c3ZpdFdWc3BnNmtrWFJlbHVLQTFmeUxraklGV2VSYm4zK0ZHUzlQWjE3Q1Bz?=
 =?utf-8?B?U1h1WlorZEVwM3NjZ1BaeWhtTXpPQzIwZlhIM0hsblMwUmtqbTdIZng3RUtX?=
 =?utf-8?B?dGgwK09jMjNSTmtBVHJqRER6UzNncmpkNkpnWHQ4eGFOSU85aVZLWnVYTWpQ?=
 =?utf-8?B?VDNYTFZjZXJOYnFBbks3OHJlNERYRlJaSTB2VnY2RWR0dEZIU2lSMU1JaWpa?=
 =?utf-8?B?YTVPbXdVM0hsdVFudTRNUHM1NWN1Vk1CWHd2WTg3cGhEZXJkTCtXd1dZR2lK?=
 =?utf-8?B?d3lKNklrWERod1ZjQ2VXS0N6VHVlSDNkSysvOUdiL3EyRnRBRkVvbWphK3h2?=
 =?utf-8?B?aXppSkVXU0lsUGZYWDhkcTVyRXNtaEFidm1EajllOFNwWHZDYmsxd3puZVZn?=
 =?utf-8?B?SWlNbFN3OUFhQ3Y3ekdzWjY2N1VyMVNrUlVMZ1R2TCt3V1VrT0pOYUl5Y216?=
 =?utf-8?B?cHpESmw2YmFDYVd1S04vd0dRYVBydDI2aklrczltT2UrMDY0UjZiRmpwMjZ6?=
 =?utf-8?B?N0VybVI5U0ZJdVRrYVlNZXdyTkp1emlPVUJUcmgvUVNNVWxUK1J3SXJ1N2Yr?=
 =?utf-8?B?clB2RzhPTFY0bThGYjQ2Y3JTN3FnR1p0KzZFTWtCTGNla0ZhbDNRK29GcGdO?=
 =?utf-8?B?L05HeGpqeW5XUTBnTGxUQ1lEYWUxeVRZVWdROEUrbGtGNzFEVUxoUWh1VXFT?=
 =?utf-8?B?WFkwNWk2WW5pWU9rWWk3ekc3OE1EQUxacG1XN052anBTamV0Qi9oSENrY01z?=
 =?utf-8?B?UG5ianA2NE5KamtQTzN3VFNSVW4raW1XTjhJV3J3cE14YVpGSnJ0dVlYM2Rr?=
 =?utf-8?B?MlhQNzZNcWxMdURVZFlTQUcyeWE0SUNPVkRhejNLOEFQWktBZktkYnpaTVV3?=
 =?utf-8?B?cE9sREJLcUFOV3VwWW0yZGdCNSszdU1XTk5GOVNSTzFCREFia1oyS0ozY2c1?=
 =?utf-8?B?VjVmRUU5WWNGVDFncjZOVjB0Zm1zNjdSRkQzTkRzenAvekxJWGxkK1p3WTdu?=
 =?utf-8?B?ZUg2SGJKRGRmcjV0QnFGcDNubWhibElOWVR2S1dzQkJwUlh1R0Z2RWlrY2tZ?=
 =?utf-8?B?dnFZK3JBaEs3dnB6UGJENk1NSUg4U2pDcG9BWlY3OFM2Y2JWUXZvT3RzZ2M5?=
 =?utf-8?B?TzN6RngxU2x0NnV5Z2M5QWdoRldBdUFVZWFQcjJUMUR3S2FZMTBaUklRNzJv?=
 =?utf-8?B?YlFNZW5PdUtQTk8xQzlzTjRHWGZQZlIxcjhpa2Ewa1Arb3FDTE4xeHNkR3NI?=
 =?utf-8?B?eFdLeVdiZVM1akdrZUNHN2FwRE9YUG5FTnhlN2FMaDBhRlBPL3VUUTA0OVZz?=
 =?utf-8?B?ZnhySElQL3AwSmdsblg5Mk1LblNsZlI1OFJSejZQTTQ5d3hycVVmbm9meldT?=
 =?utf-8?B?Q09maU0xM05hU1k3dkdoZ2EvTWJveUxKZ2VjZ2gwSVlNT0N0NTJSeWx2QzJT?=
 =?utf-8?B?LzN1eDFPOE9STEt5b0xhcXhwS2hJM1dPdW9kdW1rZC9jMVVIRy9qUnFRQ3Nm?=
 =?utf-8?B?UEpsR01wZTNKZEhjdWwrQS9oOHdYZzQzRFA5c1RTRmV2SjNJbEZGdVRIblBa?=
 =?utf-8?B?YytzQVFjalIrYkxjcTU0QlRhU2QxdHJ5d21ZaFAwS0g1a1h1TVRXeFkxaW40?=
 =?utf-8?B?b2xodHNUb2E1OExKVG5PVFY3aU9pNVV1MjZQdno3SDJyOEUxTEdQdnU5bTlk?=
 =?utf-8?B?SHNwcmZKeUhUcDJ5SHRLT05YazVSbXpxY2JKcS9SQTE1YW9aNjhHTDdrTXBz?=
 =?utf-8?B?YjR4ck9WVGNrRzZnQWVwNi9EdmVFM1k5dXRjOTZQZlVaRkxTY3B2eThJNE1a?=
 =?utf-8?B?WDF5bVVqWnNHZEltQ0NXU1EyMWI0WVRSb0czNlFqd25EU3ZuWTRnRW13bnY2?=
 =?utf-8?B?ek9KZHlWYitNamJvQng3OWloWFhLSkdIT1JIZGpZcmVzempTaC9qenhnS1FI?=
 =?utf-8?Q?Tn6Un1eXo5J1rp7MX+X2BSLE2++2aulrdfz6yR+pD7vu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55D4A6D97FC8B748B992A8B319F4D016@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dd00f346-d5b1-466c-fa70-08dc4e645ca7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 13:46:53.7938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmI+NfpN+h9fNhrkTv0pWH69X6bieDgZC1YuTulWsQo2cnd5VaIAXWme4DS6ksYbmgi2xwlT8ZbVGqBoybs3TNBYgU+r/j4iJXxZ7ih+607/3R8VjHIYF3rARJOiiyB7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEUP281MB3701

SGV5IGV2ZXJ5b25lLA0KDQp3ZSBhcmUgZGV2ZWxvcGluZyB0aGUgS1ZNIGJhY2tlbmQgZm9yIFZp
cnR1YWxCb3ggWzBdIGFuZCB3YW50ZWQgdG8gcmVhY2ggb3V0DQpyZWdhcmRpbmcgc29tZSB3ZWly
ZCBiZWhhdmlvci4NCg0KV2UgYXJlIHVzaW5nIGB0aW1lcl9jcmVhdGVgIHRvIGRlbGl2ZXIgdGlt
ZXIgZXZlbnRzIHRvIHZDUFUgdGhyZWFkcyBhcyBzaWduYWxzLg0KV2UgbWFzayB0aGUgc2lnbmFs
IHVzaW5nIHB0aHJlYWRfc2lnbWFzayBpbiB0aGUgaG9zdCB2Q1BVIHRocmVhZCBhbmQgdW5tYXNr
IHRoZW0NCmZvciBndWVzdCBleGVjdXRpb24gdXNpbmcgS1ZNX1NFVF9TSUdOQUxfTUFTSy4NCg0K
VGhpcyBtZXRob2Qgb2YgaGFuZGxpbmcgdGltZXJzIHdvcmtzIHdlbGwgYW5kIGdpdmVzIHVzIHZl
cnkgbG93IGxhdGVuY3kgYXMNCm9wcG9zZWQgdG8gdXNpbmcgYSBzZXBhcmF0ZSB0aHJlYWQgdGhh
dCBoYW5kbGVzIHRpbWVycy4gQXMgZmFyIGFzIHdlIGNhbiB0ZWxsLA0KbmVpdGhlciBRZW11IG5v
ciBvdGhlciBWTU1zIHVzZSBzdWNoIGEgc2V0dXAuIFdlIHNlZSB0d28gaXNzdWVzOg0KDQpXaGVu
IHdlIGVuYWJsZSBuZXN0ZWQgdmlydHVhbGl6YXRpb24sIHdlIHNlZSB3aGF0IGxvb2tzIGxpa2Ug
Y29ycnVwdGlvbiBpbiB0aGUNCm5lc3RlZCBndWVzdC4gVGhlIGd1ZXN0IHRyaXBzIG92ZXIgZXhj
ZXB0aW9ucyB0aGF0IHNob3VsZG4ndCBiZSB0aGVyZS4gV2UgYXJlDQpjdXJyZW50bHkgZGVidWdn
aW5nIHRoaXMgdG8gZmluZCBvdXQgZGV0YWlscywgYnV0IHRoZSBzZXR1cCBpcyBwcmV0dHkgcGFp
bmZ1bA0KYW5kIGl0IHdpbGwgdGFrZSBhIGJpdC4gSWYgd2UgZGlzYWJsZSB0aGUgdGltZXIgc2ln
bmFscywgdGhpcyBpc3N1ZSBnb2VzIGF3YXkNCihhdCB0aGUgY29zdCBvZiBicm9rZW4gVkJveCB0
aW1lcnMgb2J2aW91c2x5Li4uKS4gIFRoaXMgaXMgd2VpcmQgYW5kIGhhcyBsZWZ0IHVzDQp3b25k
ZXJpbmcsIHdoZXRoZXIgdGhlcmUgbWlnaHQgYmUgc29tZXRoaW5nIGJyb2tlbiB3aXRoIHNpZ25h
bHMgaW4gdGhpcw0Kc2NlbmFyaW8sIGVzcGVjaWFsbHkgc2luY2Ugbm9uZSBvZiB0aGUgb3RoZXIg
Vk1NcyB1c2VzIHRoaXMgbWV0aG9kLg0KDQpUaGUgb3RoZXIgaXNzdWUgaXMgdGhhdCB3ZSBoYXZl
IGEgc29tZXdoYXQgc2FkIGludGVyYWN0aW9uIHdpdGggc3BsaXQtbG9jaw0KZGV0ZWN0aW9uLCB3
aGljaCBJJ3ZlIGJsb2dnZWQgYWJvdXQgc29tZSB0aW1lIGFnbyBbMV0uIExvbmcgc3Rvcnkgc2hv
cnQ6IFdoZW4NCnlvdSBwcm9ncmFtIHRpbWVycyA8MTBtcyBpbnRvIHRoZSBmdXR1cmUsIHlvdSBy
dW4gdGhlIHJpc2sgb2YgbWFraW5nIG5vIHByb2dyZXNzDQphbnltb3JlIHdoZW4gdGhlIGd1ZXN0
IHRyaWdnZXJzIHRoZSBzcGxpdC1sb2NrIHB1bmlzaG1lbnQgWzJdLiBTZWUgdGhlIGJsb2cgcG9z
dA0KZm9yIGRldGFpbHMuIEkgd2FzIHdvbmRlcmluZyB3aGV0aGVyIHRoZXJlIGlzIGEgYmV0dGVy
IHNvbHV0aW9uIGhlcmUgdGhhbg0KZGlzYWJsaW5nIHRoZSBzcGxpdC1sb2NrIGRldGVjdGlvbiBv
ciB3aGV0aGVyIG91ciBhcHByb2FjaCBoZXJlIGlzIGZ1bmRhbWVudGFsbHkNCmJyb2tlbi4NCg0K
TG9va2luZyBmb3J3YXJkIHRvIHlvdXIgdGhvdWdodHMuIDopDQoNClRoYW5rcyENCkp1bGlhbg0K
DQpbMF0gaHR0cHM6Ly9naXRodWIuY29tL2N5YmVydXMtdGVjaG5vbG9neS92aXJ0dWFsYm94LWt2
bQ0KWzFdIGh0dHBzOi8veDg2LmxvbC9nZW5lcmljLzIwMjMvMTEvMDcvc3BsaXQtbG9jay5odG1s
DQpbMl0NCmh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xpbnV4L3Y2LjktcmMxL3NvdXJjZS9h
cmNoL3g4Ni9rZXJuZWwvY3B1L2ludGVsLmMjTDExMzcNCg==

